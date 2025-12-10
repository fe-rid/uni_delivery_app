import 'package:university_delivery_app/domain/repositories/auth_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for user logout
class LogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call() async {
    return await repository.logout();
  }
}

