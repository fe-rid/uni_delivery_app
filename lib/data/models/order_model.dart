import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/domain/entities/cart_item_entity.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';
import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/data/models/menu_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.restaurantId,
    required super.restaurantName,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.deliveryAddress,
    super.runnerId,
    super.runnerName,
    required super.createdAt,
    super.updatedAt,
  });

  /// Convert Firestore document to model
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Parse items
    List<CartItemEntity> items = [];
    if (data['items'] != null) {
      final itemsList = data['items'] as List;
      items = itemsList.map((item) {
        final menuItemData = item['menuItem'] as Map<String, dynamic>;
        // Create MenuItemEntity directly from map data
        final menuItem = MenuItemEntity(
          id: menuItemData['id'] ?? '',
          restaurantId: menuItemData['restaurantId'] ?? '',
          name: menuItemData['name'] ?? '',
          description: menuItemData['description'] ?? '',
          price: (menuItemData['price'] ?? 0.0).toDouble(),
          imageUrl: menuItemData['imageUrl'],
          category: menuItemData['category'] ?? '',
          isAvailable: menuItemData['isAvailable'] ?? true,
        );
        return CartItemEntity(
          menuItem: menuItem,
          quantity: item['quantity'] ?? 1,
        );
      }).toList();
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      items: items,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      deliveryAddress: data['deliveryAddress'] ?? '',
      runnerId: data['runnerId'],
      runnerName: data['runnerName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => {
        'menuItem': {
          'id': item.menuItem.id,
          'restaurantId': item.menuItem.restaurantId,
          'name': item.menuItem.name,
          'description': item.menuItem.description,
          'price': item.menuItem.price,
          'imageUrl': item.menuItem.imageUrl,
          'category': item.menuItem.category,
          'isAvailable': item.menuItem.isAvailable,
        },
        'quantity': item.quantity,
      }).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'runnerId': runnerId,
      'runnerName': runnerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Convert model to entity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: items,
      totalAmount: totalAmount,
      status: status,
      deliveryAddress: deliveryAddress,
      runnerId: runnerId,
      runnerName: runnerName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

