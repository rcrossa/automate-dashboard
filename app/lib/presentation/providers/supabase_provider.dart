import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

/// Centralized Supabase Client Provider
/// Use this instead of Supabase.instance.client in repository providers
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) {
  return Supabase.instance.client;
}
