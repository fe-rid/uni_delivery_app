import 'package:equatable/equatable.dart';

abstract class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantsEvent extends RestaurantsEvent {
  const LoadRestaurantsEvent();
}

