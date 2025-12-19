import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/supabase_company_repository.dart';
import '../../domain/repositories/company_repository.dart';
import 'supabase_provider.dart';

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return SupabaseCompanyRepository(ref.watch(supabaseClientProvider));
});
