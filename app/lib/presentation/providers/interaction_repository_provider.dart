import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/supabase_interaction_repository.dart';
import '../../domain/repositories/interaction_repository.dart';
import 'supabase_provider.dart';

part 'interaction_repository_provider.g.dart';

@Riverpod(keepAlive: true)
InteractionRepository interactionRepository(Ref ref) {
  return SupabaseInteractionRepository(ref.watch(supabaseClientProvider));
}
