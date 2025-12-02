import 'package:equatable/equatable.dart';
import 'package:university_delivery_app/domain/entities/restaurant_entity.dart';

abstract class RestaurantsState extends Equatable {
  const RestaurantsState();

  @override
  List<Object?> get props => [];
}

class RestaurantsInitial extends RestaurantsState {
  const RestaurantsInitial();
}

class RestaurantsLoading extends RestaurantsState {
  const RestaurantsLoading();
}

class RestaurantsLoaded extends RestaurantsState {
  final List<RestaurantEntity> restaurants;

  const RestaurantsLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantsError extends RestaurantsState {
  final String message;

  const RestaurantsError(this.message);

  @override
  List<Object?> get props => [message];
}

