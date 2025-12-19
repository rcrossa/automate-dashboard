import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_user_repository.dart';
import '../../domain/repositories/user_repository.dart';
import 'supabase_provider.dart';

part 'user_repository_provider.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return SupabaseUserRepository(ref.watch(supabaseClientProvider));
}
