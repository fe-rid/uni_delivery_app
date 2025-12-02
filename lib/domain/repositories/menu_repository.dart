import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';

abstract class MenuRepository {
  /// Get menu items for a specific restaurant
  Future<List<MenuItemEntity>> getMenuItems(String restaurantId);

  /// Get menu item by ID
  Future<MenuItemEntity?> getMenuItemById(String id);

  /// Stream menu items for real-time updates
  Stream<List<MenuItemEntity>> menuItemsStream(String restaurantId);
}

