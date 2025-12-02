import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double rating;
  final String address;
  final String phone;
  final bool isOpen;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.rating,
    required this.address,
    required this.phone,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, rating, address, phone, isOpen];
}

