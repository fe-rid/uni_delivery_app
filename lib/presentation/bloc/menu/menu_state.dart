import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<MenuItemEntity> menuItems;

  const MenuLoaded(this.menuItems);

  @override
  List<Object?> get props => [menuItems];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}

