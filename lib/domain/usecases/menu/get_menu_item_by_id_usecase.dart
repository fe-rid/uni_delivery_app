import 'package:university_delivery_app/domain/entities/menu_item_entity.dart';
import 'package:university_delivery_app/domain/repositories/menu_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting a menu item by ID
class GetMenuItemByIdUseCase implements UseCase<MenuItemEntity?, GetMenuItemByIdParams> {
  final MenuRepository repository;

  GetMenuItemByIdUseCase(this.repository);

  @override
  Future<MenuItemEntity?> call(GetMenuItemByIdParams params) async {
    return await repository.getMenuItemById(params.id);
  }
}

/// Parameters for get menu item by ID use case
class GetMenuItemByIdParams {
  final String id;

  GetMenuItemByIdParams({required this.id});
}

