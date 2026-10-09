import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoggedIn = false;

  String _savedEmail = '';
  String _savedPassword = '';
  String _currentName = '';
  String _currentEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get savedEmail => _savedEmail;
  String get savedPassword => _savedPassword;
  String get currentName => _currentName;
  String get currentEmail => _currentEmail;

  AuthProvider() {
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    final user = _auth.currentUser;

    _isLoggedIn = user != null;
    _savedEmail = prefs.getString('savedEmail') ?? '';
    _savedPassword = prefs.getString('savedPassword') ?? '';

    if (user != null) {
      _currentEmail = user.email ?? '';
      _currentName = prefs.getString('name_$_currentEmail') ?? '';
    } else {
      _currentEmail = '';
      _currentName = '';
    }

    notifyListeners();
  }

  Future<bool> login(
      String email,
      String password, {
        bool rememberPassword = false,
      }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _isLoggedIn = true;
      _currentEmail = email.trim();
      _currentName = prefs.getString('name_$_currentEmail') ?? '';

      if (rememberPassword) {
        _savedEmail = email.trim();
        _savedPassword = password.trim();

        await prefs.setString('savedEmail', _savedEmail);
        await prefs.setString('savedPassword', _savedPassword);
      }

      await prefs.setString('currentEmail', _currentEmail);
      await prefs.setString('currentName', _currentName);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _isLoggedIn = true;
      _currentName = name.trim();
      _currentEmail = email.trim();

      await prefs.setString('name_$_currentEmail', _currentName);
      await prefs.setString('currentName', _currentName);
      await prefs.setString('currentEmail', _currentEmail);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await _auth.signOut();

    _isLoggedIn = false;
    _currentName = '';
    _currentEmail = '';

    await prefs.remove('currentName');
    await prefs.remove('currentEmail');

    notifyListeners();
  }
}