import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/domain/repositories/transcripcion_repository.dart';
import 'package:msasb_app/data/repositories/supabase_transcripcion_repository.dart';
import 'supabase_provider.dart';

part 'transcripcion_repository_provider.g.dart';

@Riverpod(keepAlive: true)
TranscripcionRepository transcripcionRepository(Ref ref) {
  final supabase = Supabase.instance.client;
  return SupabaseTranscripcionRepository(supabase);
}
