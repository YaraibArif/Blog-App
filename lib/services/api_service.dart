import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  // Set token
  static void setAuthToken(String token) {
    headers["Authorization"] = "Bearer $token";
  }

  // Clear token
  static void clearAuthToken() {
    headers.remove("Authorization");
  }

  // GET
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse("$baseUrl$endpoint"), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("GET failed: ${response.statusCode} → ${response.body}");
    }
  }

  // POST
  static Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("POST failed: ${response.statusCode} → ${response.body}");
    }
  }

  // PUT
  static Future<Map<String, dynamic>> putRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("PUT failed: ${response.statusCode} → ${response.body}");
    }
  }

  // DELETE
  static Future<Map<String, dynamic>> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } else {
      throw Exception("DELETE failed: ${response.statusCode} → ${response.body}");
    }
  }
}
