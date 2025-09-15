
abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String name);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}