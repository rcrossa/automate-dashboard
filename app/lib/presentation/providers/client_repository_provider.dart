import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:msasb_app/data/repositories/supabase_client_repository.dart';
import 'package:msasb_app/domain/repositories/client_repository.dart';
import 'supabase_provider.dart';

part 'client_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ClientRepository clientRepository(Ref ref) {
  return SupabaseClientRepository(ref.watch(supabaseClientProvider));
}
