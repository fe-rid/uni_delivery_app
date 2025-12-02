import 'package:university_delivery_app/data/datasources/firestore_menu_datasource.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';
import 'package:university_delivery_app/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final FirestoreMenuDataSource _dataSource = FirestoreMenuDataSourceImpl();

  @override
  Future<List<MenuItemEntity>> getMenuItems(String restaurantId) async {
    final models = await _dataSource.getMenuItems(restaurantId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MenuItemEntity?> getMenuItemById(String id) async {
    final model = await _dataSource.getMenuItemById(id);
    return model?.toEntity();
  }

  @override
  Stream<List<MenuItemEntity>> menuItemsStream(String restaurantId) {
    return _dataSource.menuItemsStream(restaurantId).map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}

