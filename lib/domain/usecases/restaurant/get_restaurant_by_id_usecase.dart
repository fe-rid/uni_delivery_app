import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';
import 'package:university_delivery_app/domain/repositories/restaurant_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting a restaurant by ID
class GetRestaurantByIdUseCase implements UseCase<RestaurantEntity?, GetRestaurantByIdParams> {
  final RestaurantRepository repository;

  GetRestaurantByIdUseCase(this.repository);

  @override
  Future<RestaurantEntity?> call(GetRestaurantByIdParams params) async {
    return await repository.getRestaurantById(params.id);
  }
}

/// Parameters for get restaurant by ID use case
class GetRestaurantByIdParams {
  final String id;

  GetRestaurantByIdParams({required this.id});
}

