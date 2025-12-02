import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuItemsEvent extends MenuEvent {
  final String restaurantId;

  const LoadMenuItemsEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

