abstract class ModuleRepository {
  // Catálogo
  Future<List<Map<String, dynamic>>> getModules();

  // Obtener módulos activos (Agregado)
  Future<List<String>> getActiveModules({required int? companyId, int? branchId});

  // Nivel Empresa
  Future<void> toggleCompanyModule({required int companyId, required int moduleId, required bool isActive});

  // Nivel Sucursal
  Future<List<String>> getBranchModules({required int branchId});
  Future<void> toggleBranchModule({
    required int branchId,
    required String moduleCode,
    required bool isActive,
    double? customPrice,
  });

  // Nivel Usuario
  Future<List<String>> getUserModules({required String userId});
  Future<void> toggleUserModule({
    required String userId,
    required String moduleCode,
    required bool isActive,
    double? customPrice,
  });
}
