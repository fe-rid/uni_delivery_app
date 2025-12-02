import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';

abstract class RestaurantRepository {
  /// Get all restaurants
  Future<List<RestaurantEntity>> getRestaurants();

  /// Get restaurant by ID
  Future<RestaurantEntity?> getRestaurantById(String id);

  /// Stream restaurants for real-time updates
  Stream<List<RestaurantEntity>> restaurantsStream();
}

