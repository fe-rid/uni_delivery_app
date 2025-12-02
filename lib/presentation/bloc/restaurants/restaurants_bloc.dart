import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/domain/repositories/restaurant_repository.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_event.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final RestaurantRepository restaurantRepository;

  RestaurantsBloc({required this.restaurantRepository}) : super(const RestaurantsInitial()) {
    on<LoadRestaurantsEvent>(_onLoadRestaurants);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurantsEvent event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(const RestaurantsLoading());
    try {
      final restaurants = await restaurantRepository.getRestaurants();
      emit(RestaurantsLoaded(restaurants));
    } catch (e) {
      emit(RestaurantsError(e.toString()));
    }
  }
}

