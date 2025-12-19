import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_crm_config_repository.dart';
import '../../domain/repositories/crm_config_repository.dart';
import 'supabase_provider.dart';

part 'crm_config_repository_provider.g.dart';

@Riverpod(keepAlive: true)
CrmConfigRepository crmConfigRepository(Ref ref) {
  return SupabaseCrmConfigRepository(ref.watch(supabaseClientProvider));
}
