import 'package:university_delivery_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<UserEntity> login(String email, String password);

  /// Register a new user
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current authenticated user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is authenticated
  Stream<UserEntity?> authStateChanges();
}

