import 'package:university_delivery_app/data/datasources/firestore_restaurant_datasource.dart';
import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';
import 'package:university_delivery_app/domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final FirestoreRestaurantDataSource _dataSource = FirestoreRestaurantDataSourceImpl();

  @override
  Future<List<RestaurantEntity>> getRestaurants() async {
    final models = await _dataSource.getRestaurants();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RestaurantEntity?> getRestaurantById(String id) async {
    final model = await _dataSource.getRestaurantById(id);
    return model?.toEntity();
  }

  @override
  Stream<List<RestaurantEntity>> restaurantsStream() {
    return _dataSource.restaurantsStream().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}

