import 'package:university_delivery_app/data/datasources/firestore_order_datasource.dart';
import 'package:university_delivery_app/data/models/order_model.dart';
import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirestoreOrderDataSource _dataSource = FirestoreOrderDataSourceImpl();

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    final orderModel = OrderModel(
      id: order.id,
      userId: order.userId,
      restaurantId: order.restaurantId,
      restaurantName: order.restaurantName,
      items: order.items,
      totalAmount: order.totalAmount,
      status: order.status,
      deliveryAddress: order.deliveryAddress,
      runnerId: order.runnerId,
      runnerName: order.runnerName,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    );

    final createdOrder = await _dataSource.createOrder(orderModel);
    return createdOrder.toEntity();
  }

  @override
  Future<List<OrderEntity>> getOrdersByUser(String userId) async {
    final models = await _dataSource.getOrdersByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersByRunner(String runnerId) async {
    final models = await _dataSource.getOrdersByRunner(runnerId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<OrderEntity>> getPendingOrders() async {
    final models = await _dataSource.getPendingOrders();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final model = await _dataSource.getOrderById(orderId);
    return model?.toEntity();
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String? runnerId,
    String? runnerName,
  }) async {
    await _dataSource.updateOrderStatus(
      orderId,
      status,
      runnerId: runnerId,
      runnerName: runnerName,
    );
  }

  @override
  Stream<List<OrderEntity>> ordersStream(String userId) {
    return _dataSource.ordersStream(userId).map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Stream<List<OrderEntity>> pendingOrdersStream() {
    return _dataSource.pendingOrdersStream().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}

