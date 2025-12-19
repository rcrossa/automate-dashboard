import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/supabase_cliente_repository.dart';
import '../../domain/repositories/cliente_repository.dart';
import 'supabase_provider.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  return SupabaseClienteRepository(ref.watch(supabaseClientProvider));
});
