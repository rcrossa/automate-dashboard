abstract class CompanyRepository {
  // === SUCURSALES ===
  Future<List<Map<String, dynamic>>> getBranches({required int companyId});
  Future<void> createBranch({required String name, required String address, required int companyId});
  Future<void> updateBranch({required int id, required String name, required String address, required int companyId});

  // === PERSONAL ===
  Future<List<Map<String, dynamic>>> getEmployees({required int companyId});
  Future<void> inviteEmployee({
    required String email,
    required int? branchId,
    required String roleName,
    required int companyId,
  });
  Future<void> updateEmployee({
    required String userId,
    required int? branchId,
    required String roleName,
    String? name,
    String? lastName,
    String? username,
    String? phone,
    String? address,
    String? documentId,
    required int companyId,
  });
}
