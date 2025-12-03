import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/domain/entities/order_entity.dart';
import 'package:university_delivery_app/domain/repositories/order_repository.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_event.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository orderRepository;

  OrdersBloc({required this.orderRepository}) : super(const OrdersInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadPendingOrdersEvent>(_onLoadPendingOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final order = OrderEntity(
        id: const Uuid().v4(),
        userId: event.userId,
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        items: event.items,
        totalAmount: event.totalAmount,
        status: AppConstants.orderStatusPending,
        deliveryAddress: event.deliveryAddress,
        createdAt: DateTime.now(),
      );

      final createdOrder = await orderRepository.createOrder(order);
      emit(OrderCreated(createdOrder));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final orders = await orderRepository.getOrdersByUser(event.userId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onLoadPendingOrders(
    LoadPendingOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final orders = await orderRepository.getPendingOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await orderRepository.updateOrderStatus(
        event.orderId,
        event.status,
        runnerId: event.runnerId,
        runnerName: event.runnerName,
      );
      // Reload orders if needed
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}

