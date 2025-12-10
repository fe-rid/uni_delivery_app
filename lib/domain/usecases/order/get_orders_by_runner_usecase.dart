import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for getting orders by runner ID
class GetOrdersByRunnerUseCase implements UseCase<List<OrderEntity>, GetOrdersByRunnerParams> {
  final OrderRepository repository;

  GetOrdersByRunnerUseCase(this.repository);

  @override
  Future<List<OrderEntity>> call(GetOrdersByRunnerParams params) async {
    return await repository.getOrdersByRunner(params.runnerId);
  }
}

/// Parameters for get orders by runner use case
class GetOrdersByRunnerParams {
  final String runnerId;

  GetOrdersByRunnerParams({required this.runnerId});
}

