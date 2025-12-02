import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/models/order_model.dart';

abstract class FirestoreOrderDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrdersByUser(String userId);
  Future<List<OrderModel>> getOrdersByRunner(String runnerId);
  Future<List<OrderModel>> getPendingOrders();
  Future<OrderModel?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status, {String? runnerId, String? runnerName});
  Stream<List<OrderModel>> ordersStream(String userId);
  Stream<List<OrderModel>> pendingOrdersStream();
}

class FirestoreOrderDataSourceImpl implements FirestoreOrderDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.ordersCollection)
          .doc();

      final orderWithId = OrderModel(
        id: docRef.id,
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

      await docRef.set(orderWithId.toFirestore());

      return orderWithId;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByRunner(String runnerId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('runnerId', isEqualTo: runnerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get runner orders: $e');
    }
  }

  @override
  Future<List<OrderModel>> getPendingOrders() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('status', isEqualTo: AppConstants.orderStatusPending)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending orders: $e');
    }
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .get();

      if (!doc.exists) return null;

      return OrderModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String? runnerId,
    String? runnerName,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (runnerId != null) {
        updateData['runnerId'] = runnerId;
      }
      if (runnerName != null) {
        updateData['runnerName'] = runnerName;
      }

      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Stream<List<OrderModel>> ordersStream(String userId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<OrderModel>> pendingOrdersStream() {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('status', isEqualTo: AppConstants.orderStatusPending)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }
}

