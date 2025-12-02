import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/cart_item_entity.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrdersEvent {
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String deliveryAddress;

  const CreateOrderEvent({
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
  });

  @override
  List<Object?> get props => [
        userId,
        restaurantId,
        restaurantName,
        items,
        totalAmount,
        deliveryAddress,
      ];
}

class LoadOrdersEvent extends OrdersEvent {
  final String userId;

  const LoadOrdersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadPendingOrdersEvent extends OrdersEvent {
  const LoadPendingOrdersEvent();
}

class UpdateOrderStatusEvent extends OrdersEvent {
  final String orderId;
  final String status;
  final String? runnerId;
  final String? runnerName;

  const UpdateOrderStatusEvent({
    required this.orderId,
    required this.status,
    this.runnerId,
    this.runnerName,
  });

  @override
  List<Object?> get props => [orderId, status, runnerId, runnerName];
}

