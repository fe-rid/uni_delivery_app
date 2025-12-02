import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';

class CartItemEntity extends Equatable {
  final MenuItemEntity menuItem;
  final int quantity;

  const CartItemEntity({
    required this.menuItem,
    required this.quantity,
  });

  double get totalPrice => menuItem.price * quantity;

  @override
  List<Object?> get props => [menuItem, quantity];
}

