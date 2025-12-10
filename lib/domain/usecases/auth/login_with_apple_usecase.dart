import 'package:university_delivery_app/domain/entities/user_entity.dart';
import 'package:university_delivery_app/domain/repositories/auth_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for Apple sign-in
class LoginWithAppleUseCase implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  LoginWithAppleUseCase(this.repository);

  @override
  Future<UserEntity> call() async {
    return await repository.loginWithApple();
  }
}

