import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting an order by ID
class GetOrderByIdUseCase implements UseCase<OrderEntity?, GetOrderByIdParams> {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<OrderEntity?> call(GetOrderByIdParams params) async {
    return await repository.getOrderById(params.orderId);
  }
}

/// Parameters for get order by ID use case
class GetOrderByIdParams {
  final String orderId;

  GetOrderByIdParams({required this.orderId});
}

