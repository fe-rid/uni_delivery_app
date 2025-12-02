import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/domain/entities/cart_item_entity.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';
import 'package:university_delivery_app/presentation/bloc/cart/cart_event.dart';
import 'package:university_delivery_app/presentation/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    if (existingIndex >= 0) {
      // Increase quantity
      currentItems[existingIndex] = CartItemEntity(
        menuItem: currentItems[existingIndex].menuItem,
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      // Add new item
      currentItems.add(CartItemEntity(
        menuItem: event.menuItem,
        quantity: 1,
      ));
    }

    emit(state.copyWith(items: currentItems));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    currentItems.removeWhere((item) => item.menuItem.id == event.menuItemId);
    emit(state.copyWith(items: currentItems));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}

