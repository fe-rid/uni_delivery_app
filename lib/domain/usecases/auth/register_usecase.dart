import 'package:university_delivery_app/domain/entities/user_entity.dart';
import 'package:university_delivery_app/domain/repositories/auth_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for user registration
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      role: params.role,
    );
  }
}

/// Parameters for register use case
class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String role;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
  });
}

