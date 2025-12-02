import 'package:university_delivery_app/domain/entities/order_entity.dart';

abstract class OrderRepository {
  /// Create a new order
  Future<OrderEntity> createOrder(OrderEntity order);

  /// Get orders by user ID
  Future<List<OrderEntity>> getOrdersByUser(String userId);

  /// Get orders by runner ID
  Future<List<OrderEntity>> getOrdersByRunner(String runnerId);

  /// Get pending orders (for runners)
  Future<List<OrderEntity>> getPendingOrders();

  /// Get order by ID
  Future<OrderEntity?> getOrderById(String orderId);

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status, {String? runnerId, String? runnerName});

  /// Stream orders for real-time updates
  Stream<List<OrderEntity>> ordersStream(String userId);

  /// Stream pending orders
  Stream<List<OrderEntity>> pendingOrdersStream();
}

