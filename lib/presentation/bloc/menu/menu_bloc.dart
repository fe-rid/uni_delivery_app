import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/domain/repositories/menu_repository.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_event.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(const MenuInitial()) {
    on<LoadMenuItemsEvent>(_onLoadMenuItems);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItemsEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoading());
    try {
      final menuItems = await menuRepository.getMenuItems(event.restaurantId);
      emit(MenuLoaded(menuItems));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }
}

