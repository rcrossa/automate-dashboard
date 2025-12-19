import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/domain/entities/user_session.dart';

import 'package:msasb_app/domain/entities/empresa.dart';
import 'package:msasb_app/domain/entities/sucursal.dart';

import 'auth_repository_provider.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserState extends _$UserState {
  @override
  FutureOr<UserSession> build() async {
    return _loadSession();
  }

  Future<UserSession> _loadSession() async {
    // 1. Cargar usuario usando el Repositorio
    final authRepo = ref.read(authRepositoryProvider);
    final usuario = await authRepo.getCurrentUser();
    if (usuario == null) {
      return const UserSession();
    }

    // 2. Single-tenant: empresa_id siempre es 1
    const empresaId = 1;
    
    // 3. Cargar preferencias guardadas para sucursal
    final prefs = await SharedPreferences.getInstance();
    final sucursalId = prefs.getInt('sucursal_id') ?? usuario.sucursalId;

    Empresa? empresa;
    Sucursal? sucursal;

    // 4. Cargar Empresa única (siempre ID=1)
    try {
      final resp = await Supabase.instance.client
          .from('empresas')
          .select()
          .eq('id', empresaId)
          .single();
      empresa = Empresa.fromJson(resp);
    } catch (e) {
      // Si falla, la empresa no existe en BD
      debugPrint('Error loading empresa: $e');
    }

    // 5. Cargar Sucursal si existe
    if (sucursalId != null) {
      try {
        final resp = await Supabase.instance.client
            .from('sucursales')
            .select()
            .eq('id', sucursalId)
            .single();
        sucursal = Sucursal.fromJson(resp);
      } catch (e) {
        await prefs.remove('sucursal_id');
      }
    }

    return UserSession(
      usuario: usuario,
      empresa: empresa,
      sucursal: sucursal,
      themeColor: empresa?.colorTema != null ? _parseColor(empresa!.colorTema!) : null,
    );
  }

  // Single-tenant: No need for setCompany, empresa is always ID=1

  Future<void> setBranch(Sucursal? sucursal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      if (sucursal != null) {
        await prefs.setInt('sucursal_id', sucursal.id);
      } else {
        await prefs.remove('sucursal_id');
      }

      final currentSession = state.value ?? const UserSession();
      return currentSession.copyWith(
        sucursal: sucursal,
        clearSucursal: sucursal == null,
      );
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _loadSession());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    // Single-tenant: empresa_id is always 1, only clear sucursal
    await prefs.remove('sucursal_id');
    state = const AsyncValue.data(UserSession());
  }

  Color? _parseColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }
}
