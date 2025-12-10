import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting orders by user ID
class GetOrdersByUserUseCase implements UseCase<List<OrderEntity>, GetOrdersByUserParams> {
  final OrderRepository repository;

  GetOrdersByUserUseCase(this.repository);

  @override
  Future<List<OrderEntity>> call(GetOrdersByUserParams params) async {
    return await repository.getOrdersByUser(params.userId);
  }
}

/// Parameters for get orders by user use case
class GetOrdersByUserParams {
  final String userId;

  GetOrdersByUserParams({required this.userId});
}

