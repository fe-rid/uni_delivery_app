import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/repositories/order_repository_impl.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_event.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_state.dart';

class RunnerOrdersPage extends StatelessWidget {
  const RunnerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: BlocProvider(
        create: (context) => OrdersBloc(
          orderRepository: OrderRepositoryImpl(),
        )..add(LoadOrdersEvent(userId: userId)),
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrdersBloc>().add(LoadOrdersEvent(userId: userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is OrdersLoaded) {
              // Filter orders assigned to this runner
              final runnerOrders = state.orders.where(
                (order) => order.runnerId == userId,
              ).toList();

              if (runnerOrders.isEmpty) {
                return const Center(
                  child: Text('No orders assigned to you'),
                );
              }

              final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
              final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: runnerOrders.length,
                itemBuilder: (context, index) {
                  final order = runnerOrders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text('Order #${order.id.substring(0, 8)}'),
                      subtitle: Text(
                        dateFormat.format(order.createdAt),
                      ),
                      trailing: _buildStatusChip(order.status),
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
                              if (order.status == AppConstants.orderStatusAccepted ||
                                  order.status == AppConstants.orderStatusOnTheWay) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    if (order.status == AppConstants.orderStatusAccepted)
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _updateOrderStatus(
                                            context,
                                            order.id,
                                            AppConstants.orderStatusOnTheWay,
                                          ),
                                          child: const Text('On The Way'),
                                        ),
                                      ),
                                    if (order.status == AppConstants.orderStatusOnTheWay) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _updateOrderStatus(
                                            context,
                                            order.id,
                                            AppConstants.orderStatusDelivered,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text('Mark Delivered'),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case AppConstants.orderStatusPending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case AppConstants.orderStatusAccepted:
        color = Colors.blue;
        label = 'Accepted';
        break;
      case AppConstants.orderStatusOnTheWay:
        color = Colors.purple;
        label = 'On The Way';
        break;
      case AppConstants.orderStatusDelivered:
        color = Colors.green;
        label = 'Delivered';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    String orderId,
    String status,
  ) async {
    try {
      context.read<OrdersBloc>().add(
            UpdateOrderStatusEvent(
              orderId: orderId,
              status: status,
            ),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $status'),
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

