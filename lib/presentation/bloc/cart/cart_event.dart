import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final MenuItemEntity menuItem;

  const AddToCartEvent({required this.menuItem});

  @override
  List<Object?> get props => [menuItem];
}

class RemoveFromCartEvent extends CartEvent {
  final String menuItemId;

  const RemoveFromCartEvent({required this.menuItemId});

  @override
  List<Object?> get props => [menuItemId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

