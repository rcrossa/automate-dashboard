import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_admin_repository.dart';
import '../../domain/repositories/admin_repository.dart';
import 'supabase_provider.dart';

part 'admin_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AdminRepository adminRepository(Ref ref) {
  return SupabaseAdminRepository(ref.watch(supabaseClientProvider));
}
