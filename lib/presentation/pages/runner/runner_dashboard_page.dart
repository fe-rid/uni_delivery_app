import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/models/order_model.dart';
import 'package:university_delivery_app/data/repositories/order_repository_impl.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_event.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RunnerDashboardPage extends StatelessWidget {
  const RunnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runner Dashboard'),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _getPendingOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text('No pending orders'),
            );
          }

          final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
          final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    dateFormat.format(order.createdAt),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant: ${order.restaurantName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Address: ${order.deliveryAddress}'),
                          const SizedBox(height: 16),
                          const Divider(),
                          ...order.items.map(
                            (item) => ListTile(
                              dense: true,
                              title: Text(item.menuItem.name),
                              subtitle: Text('Qty: ${item.quantity}'),
                              trailing: Text(
                                currencyFormat.format(item.totalPrice),
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                currencyFormat.format(order.totalAmount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _acceptOrder(context, order.id),
                              child: const Text('Accept Order'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<OrderModel>> _getPendingOrdersStream() {
    return FirebaseFirestore.instance
        .collection(AppConstants.ordersCollection)
        .where('status', isEqualTo: AppConstants.orderStatusPending)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  Future<void> _acceptOrder(BuildContext context, String orderId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Get user name
    final userDoc = await FirebaseFirestore.instance
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    final userName = userDoc.data()?['name'] ?? 'Runner';

    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': AppConstants.orderStatusAccepted,
        'runnerId': userId,
        'runnerName': userName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order accepted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

