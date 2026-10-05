import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

  Future<Map<String, dynamic>> login(String email, String password) {
    return service.login(email, password);
  }

  Future<Map<String, dynamic>> getUser(String token) {
    return service.getUser(token);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) {
    return service.register(name, email, password);
  }
}
