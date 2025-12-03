import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:university_delivery_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/cart/cart_event.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_event.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_state.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_state.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    final cartState = context.read<CartBloc>().state;
    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    // Get restaurant from first item
    final restaurantId = cartState.items.first.menuItem.restaurantId;
    final restaurantsState = context.read<RestaurantsBloc>().state;
    String restaurantName = 'Restaurant';
    
    if (restaurantsState is RestaurantsLoaded) {
      final restaurant = restaurantsState.restaurants.firstWhere(
        (r) => r.id == restaurantId,
        orElse: () => restaurantsState.restaurants.first,
      );
      restaurantName = restaurant.name;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    context.read<OrdersBloc>().add(
          CreateOrderEvent(
            userId: userId,
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            items: cartState.items,
            totalAmount: cartState.totalAmount,
            deliveryAddress: _addressController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final cartState = context.watch<CartBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: BlocListener<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            context.read<CartBloc>().add(const ClearCartEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is OrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...cartState.items.map(
                (item) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(item.menuItem.name),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(
                      currencyFormat.format(item.totalPrice),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    currencyFormat.format(cartState.totalAmount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter your delivery address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is OrdersLoading ? null : _placeOrder,
                    child: state is OrdersLoading
                        ? const CircularProgressIndicator()
                        : const Text('Place Order'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

