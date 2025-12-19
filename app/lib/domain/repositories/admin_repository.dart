abstract class AdminRepository {
  Future<void> createCompany({
    required String name,
    required String code,
    required String address,
    String? logoUrl,
    String? themeColor,
  });

  Future<void> inviteUser({
    required String email,
    required int companyId,
    required int? branchId,
    required String roleName,
  });

  Future<List<Map<String, dynamic>>> getCompanies();
  Future<List<Map<String, dynamic>>> getPendingInvitations();
  Future<void> deleteInvitation(String id);
}
