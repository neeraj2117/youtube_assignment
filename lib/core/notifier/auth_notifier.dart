import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube/core/services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService = new AuthService();

  Future<String?> signup({
    required String email,
    required String password,
  }) async {
    try {
      var response =
          await _authService.signup(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await _authService.login(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
