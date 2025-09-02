
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
  bool _isInitialized = false;

  AuthProvider() {
    _bootstrap();
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _auth.currentUser != null;
  bool get loading => _loading;
  String? get error => _error;
  bool get remember => _remember;
  bool get isInitialized => _isInitialized;

  Future<void> _bootstrap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _remember = prefs.getBool('remember') ?? true;
      
      // Check if user should be remembered from previous session
      final wasLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (_remember && wasLoggedIn && _auth.currentUser != null) {
        // Restore user session if remember me is enabled and user was logged in
        _user = await _service.currentUser();
      } else if (!_remember && _auth.currentUser != null) {
        // If remember me is disabled, clear any existing session
        await _service.logout();
        await prefs.remove('isLoggedIn');
        _user = null;
      } else if (_auth.currentUser != null) {
        // If user is currently logged in (active session), load user data
        _user = await _service.currentUser();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setRemember(bool v) async {
    _remember = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember', v);
    
    // If user disables remember me, just remove the persistent login flag
    // Don't log them out immediately - they can continue their current session
    if (!v) {
      await prefs.remove('isLoggedIn');
    }
    
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
      final prefs = await SharedPreferences.getInstance();
      if (_remember) {
        // Save login state for future app restarts
        await prefs.setBool('isLoggedIn', true);
      } else {
        // Don't save login state, user will need to login again after app restart
        await prefs.remove('isLoggedIn');
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
      final prefs = await SharedPreferences.getInstance();
      if (_remember) {
        // Save login state for future app restarts
        await prefs.setBool('isLoggedIn', true);
      } else {
        // Don't save login state, user will need to login again after app restart
        await prefs.remove('isLoggedIn');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _loading = true;
    notifyListeners();
    
    try {
      await _service.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
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
