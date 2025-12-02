import 'package:firebase_auth/firebase_auth.dart';
import 'package:university_delivery_app/data/datasources/firebase_auth_datasource.dart';
import 'package:university_delivery_app/domain/entities/user_entity.dart';
import 'package:university_delivery_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource = FirebaseAuthDataSourceImpl();

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await _dataSource.login(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    final userModel = await _dataSource.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _dataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Stream<UserEntity?> authStateChanges() async* {
    await for (final user in _dataSource.authStateChanges()) {
      if (user != null) {
        final userModel = await _dataSource.getCurrentUser();
        yield userModel?.toEntity();
      } else {
        yield null;
      }
    }
  }
}

