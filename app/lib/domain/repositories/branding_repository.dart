import 'package:msasb_app/domain/entities/empresa_branding.dart';

/// Repository para gestionar branding de empresas
abstract class BrandingRepository {
  /// Obtiene el branding de una empresa
  Future<EmpresaBranding?> getBranding(int empresaId);

  /// Actualiza el branding de una empresa
  Future<EmpresaBranding> updateBranding(EmpresaBranding branding);

  /// Sube un logo y retorna su URL
  /// Acepta File (móvil) o Uint8List (web)
  Future<String> uploadLogo(int empresaId, dynamic logoFile, {bool isLightVersion = false});

  /// Elimina un logo
  Future<void> deleteLogo(int empresaId, {bool isLightVersion = false});
}
