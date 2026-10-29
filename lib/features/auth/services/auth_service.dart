import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String email;
  final String name;
  final String institution;
  final bool isAuthenticated;

  const AuthUser({
    required this.email,
    required this.name,
    required this.institution,
    this.isAuthenticated = true,
  });

  static const AuthUser guest = AuthUser(
    email: '',
    name: 'Guest Assessor',
    institution: 'Demo Institution',
    isAuthenticated: false,
  );
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AuthUser _currentUser = AuthUser.guest;
  AuthUser get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser.isAuthenticated;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('auth_user_email');
    if (email != null && email.isNotEmpty) {
      final name = prefs.getString('auth_user_name') ?? 'Sustainability Lead';
      final inst = prefs.getString('auth_user_institution') ?? 'Greenfield University';
      _currentUser = AuthUser(email: email, name: name, institution: inst);
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password, {bool rememberMe = true}) async {
    // In production with Supabase configured, calls supabase.auth.signInWithPassword
    // Fallback deterministic local authentication:
    await Future.delayed(const Duration(milliseconds: 600));

    final name = email.split('@').first.replaceAll('.', ' ');
    final capitalized = name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : 'Sustainability Officer';

    _currentUser = AuthUser(
      email: email,
      name: capitalized,
      institution: 'Institute of Environmental Sciences',
      isAuthenticated: true,
    );

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user_email', email);
      await prefs.setString('auth_user_name', _currentUser.name);
      await prefs.setString('auth_user_institution', _currentUser.institution);
    }

    notifyListeners();
    return true;
  }

  Future<bool> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = const AuthUser(
      email: 'sustainability.director@campus.edu',
      name: 'Dr. Sarah Mitchell',
      institution: 'National University of Green Technology',
      isAuthenticated: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_user_email', _currentUser.email);
    await prefs.setString('auth_user_name', _currentUser.name);
    await prefs.setString('auth_user_institution', _currentUser.institution);

    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _currentUser = AuthUser.guest;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user_email');
    await prefs.remove('auth_user_name');
    await prefs.remove('auth_user_institution');
    notifyListeners();
  }
}
