import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'https://dummyjson.com';
  final _secureStorage = const FlutterSecureStorage();

  String? accessToken;
  String? refreshToken;

  //Login with username & password
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      accessToken = data['token'];
      refreshToken = data['refreshToken'];

      // Save securely
      await _secureStorage.write(key: "user", value: jsonEncode(data));
      await _secureStorage.write(key: "accessToken", value: accessToken);
      await _secureStorage.write(key: "refreshToken", value: refreshToken);

      return true;
    }
    return false;
  }

  //Get current user from secure storage
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userJson = await _secureStorage.read(key: "user");

    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>; // ✅ Safe Map return
    }
    return null;
  }

  // Logout user (clear tokens & storage)
  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;

    await _secureStorage.delete(key: "user");
    await _secureStorage.delete(key: "accessToken");
    await _secureStorage.delete(key: "refreshToken");
  }

  //Refresh access token
  Future<bool> refreshTokenFunc() async {
    refreshToken ??= await _secureStorage.read(key: "refreshToken");
    if (refreshToken == null) return false;

    final url = Uri.parse('$baseUrl/auth/refresh');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refreshToken': refreshToken,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['token'];

      // Save updated token securely
      await _secureStorage.write(key: "accessToken", value: accessToken);
      return true;
    }
    return false;
  }
}
