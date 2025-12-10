import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/domain/usecases/base_usecase.dart';

/// Use case for updating order status
class UpdateOrderStatusUseCase implements UseCase<void, UpdateOrderStatusParams> {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<void> call(UpdateOrderStatusParams params) async {
    return await repository.updateOrderStatus(
      params.orderId,
      params.status,
      runnerId: params.runnerId,
      runnerName: params.runnerName,
    );
  }
}

/// Parameters for update order status use case
class UpdateOrderStatusParams {
  final String orderId;
  final String status;
  final String? runnerId;
  final String? runnerName;

  UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
    this.runnerId,
    this.runnerName,
  });
}

