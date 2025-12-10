import 'package:university_delivery_app/domain/entities/user_entity.dart';
import 'package:university_delivery_app/domain/repositories/auth_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase implements UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

