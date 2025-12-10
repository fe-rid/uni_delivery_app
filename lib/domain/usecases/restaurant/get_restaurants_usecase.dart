import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';
import 'package:university_delivery_app/domain/repositories/restaurant_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting all restaurants
class GetRestaurantsUseCase implements UseCaseNoParams<List<RestaurantEntity>> {
  final RestaurantRepository repository;

  GetRestaurantsUseCase(this.repository);

  @override
  Future<List<RestaurantEntity>> call() async {
    return await repository.getRestaurants();
  }
}

