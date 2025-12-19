abstract class UserRepository {
  Future<List<dynamic>> getUsers();
  Future<List<dynamic>> getRoles();
  Future<List<dynamic>> getPermissions();
  Future<List<int>> getUserPermissions(String userId);
  Future<void> changeUserRole(String userId, int newRoleId);
  Future<void> assignPermission(String userId, int permissionId);
  Future<void> removePermission(String userId, int permissionId);
  Future<void> changeUserProfileType(String userId, String profileType);
  Future<void> updateUserProfile(String userId, {String? name, String? username});
}
