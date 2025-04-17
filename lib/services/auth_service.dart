import 'dart:async';

class AuthService {
  Future<String> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'user_123'; // Stub user ID
  }

  Future<String> signUp(String email, String password, String username) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'user_123'; // Stub user ID
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<String?> getCurrentUserId() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'user_123'; // Stub user ID
  }

  Future<String?> getCurrentUsername() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'John Doe'; // Stub username
  }
} 