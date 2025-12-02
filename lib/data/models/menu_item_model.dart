import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.category,
    required super.isAvailable,
  });

  /// Convert Firestore document to model
  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItemModel(
      id: doc.id,
      restaurantId: data['restaurantId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'],
      category: data['category'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  /// Convert model to entity
  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      restaurantId: restaurantId,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      category: category,
      isAvailable: isAvailable,
    );
  }
}

