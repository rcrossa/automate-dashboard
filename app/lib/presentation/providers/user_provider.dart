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

    // 2. Cargar preferencias guardadas o usar las del usuario
    final prefs = await SharedPreferences.getInstance();
    final empresaId = prefs.getInt('empresa_id') ?? usuario.empresaId;
    final sucursalId = prefs.getInt('sucursal_id') ?? usuario.sucursalId;

    Empresa? empresa;
    Sucursal? sucursal;

    // 3. Cargar Empresa si existe
    if (empresaId != null) {
      try {
        final resp = await Supabase.instance.client
            .from('empresas')
            .select()
            .eq('id', empresaId)
            .single();
        empresa = Empresa.fromJson(resp);
      } catch (e) {
        await prefs.remove('empresa_id');
      }
    }

    // 4. Cargar Sucursal si existe
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

  Future<void> setCompany(Empresa empresa) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('empresa_id', empresa.id);
      
      // Al cambiar empresa, limpiamos la sucursal actual si no pertenece a la nueva empresa
      // Por simplicidad, limpiamos siempre la sucursal al cambiar de empresa
      await prefs.remove('sucursal_id');

      final currentSession = state.value ?? const UserSession();
      return currentSession.copyWith(
        empresa: empresa,
        themeColor: empresa.colorTema != null ? _parseColor(empresa.colorTema!) : null,
        clearSucursal: true,
      );
    });
  }

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
    await prefs.remove('empresa_id');
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
