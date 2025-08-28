import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isLogin = false;
  String? errorMessage;
  User? currentUser;

  // OTP
  String? _generatedOtp;
  String? get generatedOtp => _generatedOtp;

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _setLoading(true);

    final userData = await _authService.getCurrentUser();
    if (userData != null) {
      currentUser = User.fromJson(userData);
      isLogin = true;
      notifyListeners();
    } else {
      isLogin = false;
    }

    _setLoading(false);
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    errorMessage = null;

    try {
      final success = await _authService.login(username, password);

      if (!success) {
        errorMessage = "Login failed. Check credentials";
        _setLoading(false);
        return false;
      }

      _generatedOtp = _generateOtp();
      debugPrint("✅ Dummy OTP Generated: $_generatedOtp");

      _setLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    if (enteredOtp == _generatedOtp) {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        currentUser = User.fromJson(userData);
        isLogin = true;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void setUser(User user) {
    currentUser = user;
    isLogin = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    currentUser = null;
    isLogin = false;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
