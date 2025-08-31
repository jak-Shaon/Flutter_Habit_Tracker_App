
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _service = AuthService();

  AppUser? _user;
  bool _loading = false;
  String? _error;
  bool _remember = true;

  AuthProvider() {
    _bootstrap();
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _auth.currentUser != null;
  bool get loading => _loading;
  String? get error => _error;
  bool get remember => _remember;

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _remember = prefs.getBool('remember') ?? true;
    if (_auth.currentUser != null) {
      _user = await _service.currentUser();
    }
    notifyListeners();
  }

  Future<void> setRemember(bool v) async {
    _remember = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember', v);
    notifyListeners();
  }

  Future<void> register({
    required String displayName,
    required String email,
    required String password,
    String? gender,
    Map<String, dynamic>? otherDetails,
    required bool agreedToTerms,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _service.register(
        displayName: displayName,
        email: email,
        password: password,
        gender: gender,
        otherDetails: otherDetails,
        agreedToTerms: agreedToTerms,
      );
      if (_remember) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _service.login(email, password);
      if (_remember) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String displayName,
    String? gender,
    Map<String, dynamic>? otherDetails,
  }) async {
    if (_user == null) return;
    final updated = _user!.copyWith(displayName: displayName, gender: gender, otherDetails: otherDetails);
    await _service.updateProfile(updated);
    _user = updated;
    notifyListeners();
  }
}
