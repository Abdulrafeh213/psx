abstract class AuthService {
  Future<void> init();
  Future<dynamic> loginWithEmail({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>?> getUser();
  Future<void> logout();
}
