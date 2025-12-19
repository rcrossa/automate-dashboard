import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/domain/repositories/branding_repository.dart';
import 'package:msasb_app/data/repositories/supabase_branding_repository.dart';
import 'package:msasb_app/presentation/providers/supabase_provider.dart';
import 'package:msasb_app/presentation/providers/user_provider.dart';

part 'branding_provider.g.dart';

/// Provider del repository de branding
@riverpod
BrandingRepository brandingRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseBrandingRepository(client);
}

/// Provider del branding de la empresa actual
@riverpod
class CompanyBranding extends _$CompanyBranding {
  @override
  Future<EmpresaBranding?> build() async {
    final session = ref.watch(userStateProvider).value;
    if (session?.empresa?.id == null) return null;

    final repo = ref.watch(brandingRepositoryProvider);
    return await repo.getBranding(session!.empresa!.id);
  }

  /// Actualiza el branding
  Future<void> updateBranding(EmpresaBranding branding) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(brandingRepositoryProvider);
      return await repo.updateBranding(branding);
    });
  }

  /// Sube logo y retorna la URL
  Future<String> uploadLogo(int empresaId, dynamic logoFile, {bool isLightVersion = false}) async {
    final repo = ref.read(brandingRepositoryProvider);
    final url = await repo.uploadLogo(empresaId, logoFile, isLightVersion: isLightVersion);
    
    // Actualizar el branding solo si estamos reemplazando
    // (esto es opcional, podemos dejarlo para el updateBranding general)
    return url;
  }

  /// Elimina logo del storage
  Future<void> deleteLogo(int empresaId, {bool isLightVersion = false}) async {
    final repo = ref.read(brandingRepositoryProvider);
    await repo.deleteLogo(empresaId, isLightVersion: isLightVersion);
  }
}
