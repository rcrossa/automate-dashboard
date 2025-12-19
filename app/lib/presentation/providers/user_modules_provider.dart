import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider to check if current user has a specific module enabled
/// 
/// Performs dual-level check:
/// 1. empresa_modulos: Company has purchased the module
/// 2. usuario_modulos: User has been assigned the module
/// 
/// Both must be true for access to be granted
final hasModuleProvider =
    FutureProvider.family<bool, String>((ref, moduleCode) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return false;

  try {
    // Get user's company
    final userResult = await supabase
        .from('usuarios')
        .select('empresa_id')
        .eq('id', userId)
        .single();

    final companyId = userResult['empresa_id'];
    if (companyId == null) return false;

    // Check 1: Does company have module enabled?
    final companyModule = await supabase
        .from('empresa_modulos')
        .select('activo, modulos!inner(codigo)')
        .eq('empresa_id', companyId)
        .eq('modulos.codigo', moduleCode)
        .maybeSingle();

    if (companyModule == null || companyModule['activo'] != true) {
      return false; // Company doesn't have module or it's inactive
    }

    // Check 2: Does user have assignment?
    final userModule = await supabase
        .from('usuario_modulos')
        .select('activo')
        .eq('usuario_id', userId)
        .eq('modulo_codigo', moduleCode)
        .maybeSingle();

    if (userModule == null || userModule['activo'] != true) {
      return false; // User not assigned or assignment inactive
    }

    // Both checks passed
    return true;
  } catch (e) {
    // Log error but return false (fail closed for security)
    print('Error checking module access for $moduleCode: $e');
    return false;
  }
});

/// Specific provider for speech-to-text module
/// 
/// Usage:
/// ```dart
/// final hasSpeech = ref.watch(hasSpeechToTextProvider);
/// hasSpeech.when(
///   data: (hasModule) => hasModule ? ShowFeature() : HideFeature(),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => ErrorWidget(e),
/// );
/// ```
final hasSpeechToTextProvider = Provider<AsyncValue<bool>>((ref) {
  return ref.watch(hasModuleProvider('speech_to_text'));
});

/// Provider to get all modules available to current user
/// 
/// Returns list of module codes that user has access to
final userAvailableModulesProvider = FutureProvider<List<String>>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return [];

  try {
    // Get user's company
    final userResult = await supabase
        .from('usuarios')
        .select('empresa_id')
        .eq('id', userId)
        .single();

    final companyId = userResult['empresa_id'];
    if (companyId == null) return [];

    // Get all user's assigned modules
    final userModules = await supabase
        .from('usuario_modulos')
        .select('modulo_codigo, activo')
        .eq('usuario_id', userId)
        .eq('activo', true);

    final userModuleCodes =
        userModules.map((m) => m['modulo_codigo'] as String).toList();

    if (userModuleCodes.isEmpty) return [];

    // Filter by company modules (dual check)
    final companyModules = await supabase
        .from('empresa_modulos')
        .select('activo, modulos!inner(codigo)')
        .eq('empresa_id', companyId)
        .eq('activo', true);

    final companyModuleCodes = companyModules
        .map((m) => m['modulos']['codigo'] as String)
        .toList();

    // Return intersection (user has AND company has)
    return userModuleCodes
        .where((code) => companyModuleCodes.contains(code))
        .toList();
  } catch (e) {
    print('Error getting user available modules: $e');
    return [];
  }
});
