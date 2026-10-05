import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';
import '../services/auth_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  final AuthStorage storage;

  AuthProvider({required this.repository, required this.storage});

  bool _isLoading = false;
  bool _isCheckingAuth = true;

  String? _error;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  bool get isCheckingAuth => _isCheckingAuth;

  String? get error => _error;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  bool get isLoggedIn => _token != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final result = await repository.login(email, password);

      _token = result['token'];
      _user = result['user'];

      await storage.saveToken(_token!);

      return true;
    } catch (e) {
      _token = null;
      _user = null;
      _handleError(e);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final result = await repository.register(name, email, password);

      _token = result['token'];
      _user = result['user'];

      await storage.saveToken(_token!);

      return true;
    } catch (e) {
      _token = null;
      _user = null;
      _handleError(e);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuth() async {
    _isCheckingAuth = true;

    notifyListeners();

    try {
      print('AUTH: mulai checkAuth');

      final savedToken = await storage.getToken();

      print('AUTH: token = $savedToken');

      if (savedToken == null) {
        print('AUTH: token tidak ditemukan');

        _token = null;
        _user = null;
        return;
      }

      print('AUTH: cek token ke API');

      final user = await repository.getUser(savedToken);

      print('AUTH: user berhasil = $user');

      _token = savedToken;
      _user = user;
    } catch (e) {
      print('AUTH ERROR: $e');

      await storage.deleteToken();

      _token = null;
      _user = null;
    } finally {
      _isCheckingAuth = false;

      print('AUTH: checkAuth selesai');

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await storage.deleteToken();

    _token = null;
    _user = null;
    _error = null;

    notifyListeners();
  }

  void _handleError(Object e) {
  final message = e.toString();

  if (message.contains('SocketException') ||
      message.contains('Connection refused')) {
    _error = 'Tidak dapat terhubung ke server';
    return;
  }

  _error = message.replaceFirst('Exception: ', '');
}
}
