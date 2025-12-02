import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String status; // pending, accepted, on_the_way, delivered
  final String deliveryAddress;
  final String? runnerId;
  final String? runnerName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.runnerId,
    this.runnerName,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        restaurantId,
        restaurantName,
        items,
        totalAmount,
        status,
        deliveryAddress,
        runnerId,
        runnerName,
        createdAt,
        updatedAt,
      ];
}

