import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    super.imageUrl,
    required super.rating,
    required super.address,
    required super.phone,
    required super.isOpen,
  });

  /// Convert Firestore document to model
  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      isOpen: data['isOpen'] ?? true,
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'address': address,
      'phone': phone,
      'isOpen': isOpen,
    };
  }

  /// Convert model to entity
  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      address: address,
      phone: phone,
      isOpen: isOpen,
    );
  }
}

