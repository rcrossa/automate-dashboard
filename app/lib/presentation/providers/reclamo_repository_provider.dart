import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_reclamo_repository.dart';
import '../../domain/repositories/reclamo_repository.dart';
import 'supabase_provider.dart';

part 'reclamo_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ReclamoRepository reclamoRepository(Ref ref) {
  return SupabaseReclamoRepository(ref.watch(supabaseClientProvider));
}
