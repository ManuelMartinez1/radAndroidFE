import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  // Método para almacenar el token en SharedPreferences
  static Future<String?> getToken() async {
    // Obtener el token del almacenamiento local
    final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    return token;
  }

  static Future<void> saveToken(String token) async {
    // Guardar el token en el almacenamiento local
    await SharedPreferences.getInstance().then((prefs) => prefs.setString('token', token));
  }
  static Future<String?> getUserRole() async {
    final token = await getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['role'];
    }
    return null;
  }
  static Future<String?> getUsername()async {
    final token = await getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['username'];
    }
    return null;
  }
  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
  static Future<void> logout() async {
    // Eliminar el token del almacenamiento local
    await SharedPreferences.getInstance().then((prefs) => prefs.remove('token'));
  }
}