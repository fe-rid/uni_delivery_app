import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for creating a new order
class CreateOrderUseCase implements UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<OrderEntity> call(CreateOrderParams params) async {
    return await repository.createOrder(params.order);
  }
}

/// Parameters for create order use case
class CreateOrderParams {
  final OrderEntity order;

  CreateOrderParams({required this.order});
}

