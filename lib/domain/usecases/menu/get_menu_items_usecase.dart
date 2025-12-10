import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';
import 'package:university_delivery_app/domain/repositories/menu_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting menu items for a restaurant
class GetMenuItemsUseCase implements UseCase<List<MenuItemEntity>, GetMenuItemsParams> {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  @override
  Future<List<MenuItemEntity>> call(GetMenuItemsParams params) async {
    return await repository.getMenuItems(params.restaurantId);
  }
}

/// Parameters for get menu items use case
class GetMenuItemsParams {
  final String restaurantId;

  GetMenuItemsParams({required this.restaurantId});
}

