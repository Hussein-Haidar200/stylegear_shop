import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  String _savedEmail = '';
  String _savedPassword = '';

  bool get isLoggedIn => _isLoggedIn;
  String get savedEmail => _savedEmail;
  String get savedPassword => _savedPassword;

  AuthProvider() {
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _savedEmail = prefs.getString('savedEmail') ?? '';
    _savedPassword = prefs.getString('savedPassword') ?? '';

    notifyListeners();
  }

  Future<bool> login(String email, String password, bool savePassword) async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = true;

    if (savePassword) {
      _savedEmail = email;
      _savedPassword = password;

      await prefs.setString('savedEmail', email);
      await prefs.setString('savedPassword', password);
    }

    await prefs.setBool('isLoggedIn', true);

    notifyListeners();
    return true;
  }

  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    String registeredEmail = prefs.getString('registeredEmail') ?? '';
    String registeredPassword = prefs.getString('registeredPassword') ?? '';

    if (email == registeredEmail && password == registeredPassword) {
      return false;
    }

    await prefs.setString('registeredEmail', email);
    await prefs.setString('registeredPassword', password);

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = false;
    await prefs.setBool('isLoggedIn', false);

    notifyListeners();
  }
}