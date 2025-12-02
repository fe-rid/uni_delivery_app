import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final bool isAvailable;

  const MenuItemEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, restaurantId, name, description, price, imageUrl, category, isAvailable];
}

