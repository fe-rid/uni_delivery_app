import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting pending orders (for runners)
class GetPendingOrdersUseCase implements UseCaseNoParams<List<OrderEntity>> {
  final OrderRepository repository;

  GetPendingOrdersUseCase(this.repository);

  @override
  Future<List<OrderEntity>> call() async {
    return await repository.getPendingOrders();
  }
}

