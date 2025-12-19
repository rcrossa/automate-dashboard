import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_module_repository.dart';
import '../../domain/repositories/module_repository.dart';
import 'supabase_provider.dart';

part 'module_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ModuleRepository moduleRepository(Ref ref) {
  return SupabaseModuleRepository(ref.watch(supabaseClientProvider));
}
