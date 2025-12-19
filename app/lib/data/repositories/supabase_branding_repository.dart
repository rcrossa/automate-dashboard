import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/core/error/failure.dart';
import 'package:msasb_app/domain/entities/empresa_branding.dart';
import 'package:msasb_app/domain/repositories/branding_repository.dart';

class SupabaseBrandingRepository implements BrandingRepository {
  final SupabaseClient _client;

  SupabaseBrandingRepository(this._client);

  @override
  Future<EmpresaBranding?> getBranding(int empresaId) async {
    try {
      final response = await _client
          .from('empresa_branding')
          .select()
          .eq('empresa_id', empresaId)
          .maybeSingle();

      if (response == null) return null;
      return EmpresaBranding.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<EmpresaBranding> updateBranding(EmpresaBranding branding) async {
    try {
      final data = branding.toJson();
      // Remove fields that shouldn't be updated
      data.remove('id');
      data.remove('empresa_id');
      data.remove('fecha_creacion');
      data.remove('actualizado_en'); // DB handles this with trigger

      final response = await _client
          .from('empresa_branding')
          .update(data)
          .eq('empresa_id', branding.empresaId)
          .select()
          .single();

      return EmpresaBranding.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> uploadLogo(
    int empresaId,
    dynamic logoFile, {
    bool isLightVersion = false,
  }) async {
    try {
      final fileName = isLightVersion 
          ? 'logo_light_${DateTime.now().millisecondsSinceEpoch}.png'
          : 'logo_${DateTime.now().millisecondsSinceEpoch}.png';
      
      final path = '$empresaId/$fileName';

      // Soportar tanto File (móvil) como bytes (web)
      if (logoFile is File) {
        await _client.storage
            .from('company-logos')
            .upload(path, logoFile);
      } else if (logoFile is Uint8List) {
        // Web: bytes directamente (Uint8List de readAsBytes())
        await _client.storage
            .from('company-logos')
            .uploadBinary(path, logoFile);
      } else {
        throw Exception('Tipo de archivo no soportado: ${logoFile.runtimeType}');
      }

      // Crear signed URL (bucket privado) - válida por 10 años
      final url = await _client.storage
          .from('company-logos')
          .createSignedUrl(path, 315360000); // 10 años en segundos

      return url;
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteLogo(
    int empresaId, {
    bool isLightVersion = false,
  }) async {
    try {
      // List files in the empresa folder
      final files = await _client.storage
          .from('company-logos')
          .list(path: '$empresaId');

      // Find and delete the logo
      final prefix = isLightVersion ? 'logo_light_' : 'logo_';
      final logoFiles = files.where((file) => file.name.startsWith(prefix));

      for (final file in logoFiles) {
        await _client.storage
            .from('company-logos')
            .remove(['$empresaId/${file.name}']);
      }
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
