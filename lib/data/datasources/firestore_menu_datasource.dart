import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/models/menu_item_model.dart';

abstract class FirestoreMenuDataSource {
  Future<List<MenuItemModel>> getMenuItems(String restaurantId);
  Future<MenuItemModel?> getMenuItemById(String id);
  Stream<List<MenuItemModel>> menuItemsStream(String restaurantId);
}

class FirestoreMenuDataSourceImpl implements FirestoreMenuDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<MenuItemModel>> getMenuItems(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.menuItemsCollection)
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      return snapshot.docs
          .map((doc) => MenuItemModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get menu items: $e');
    }
  }

  @override
  Future<MenuItemModel?> getMenuItemById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.menuItemsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return MenuItemModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get menu item: $e');
    }
  }

  @override
  Stream<List<MenuItemModel>> menuItemsStream(String restaurantId) {
    return _firestore
        .collection(AppConstants.menuItemsCollection)
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc))
            .toList());
  }
}

