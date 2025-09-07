abstract class DatabaseService {
  // ------------ Init / Setup ------------
  Future<void> init();

  // ------------ Auth ------------
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<String?> loginWithEmail({
    required String email,
    required String password,
  });

  Future<String?> loginWithPhone({required String phone});

  Future<void> sendPasswordResetEmail(String email);

  Future<void> logout();

  // ------------ User Profile ------------
  Future<Map<String, dynamic>?> getUser(String userId);

  Future<void> saveUser(String userId, Map<String, dynamic> data);

  Future<void> updateUser(String userId, Map<String, dynamic> data);

  // ------------ Location ------------
  Future<void> saveUserLocation(
    String userId, {
    required double latitude,
    required double longitude,
    required String placeName,
  });

  Future<Map<String, dynamic>?> getUserLocation(String userId);

  Future<Map<String, dynamic>?> getCurrentUser();
}
