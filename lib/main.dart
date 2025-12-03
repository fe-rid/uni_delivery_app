import 'package:firebase_core/firebase_core.dart';
import 'package:university_delivery_app/services/firebase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/app.dart';
import 'package:university_delivery_app/core/theme/app_theme.dart';
import 'package:university_delivery_app/data/repositories/auth_repository_impl.dart';
import 'package:university_delivery_app/data/repositories/menu_repository_impl.dart';
import 'package:university_delivery_app/data/repositories/order_repository_impl.dart';
import 'package:university_delivery_app/data/repositories/restaurant_repository_impl.dart';
import 'package:university_delivery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/auth/auth_event.dart';
import 'package:university_delivery_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/menu/menu_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_bloc.dart';
import 'package:university_delivery_app/presentation/bloc/restaurants/restaurants_event.dart';

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
    if (kDebugMode) {
      debugPrint('Firebase initialized successfully');
    }
    // Initialize additional Firebase services
    await FirebaseService.initialize();
  } catch (e) {
    firebaseInitialized = false;
    if (kDebugMode) {
      debugPrint('Firebase initialization error: $e');
      debugPrint('Make sure google-services.json is in android/app/');
      debugPrint('App will continue but Firebase features will not work.');
    }
    // Don't crash the app - allow it to run in demo mode
  }

  if (kDebugMode) {
    if (firebaseInitialized) {
      debugPrint('Firebase is ready - All features available');
    } else {
      debugPrint('Running in demo mode - Firebase features disabled');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepositoryImpl(),
          )..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => RestaurantsBloc(
            restaurantRepository: RestaurantRepositoryImpl(),
          )..add(const LoadRestaurantsEvent()),
        ),
        BlocProvider(
          create: (context) => MenuBloc(
            menuRepository: MenuRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => OrdersBloc(
            orderRepository: OrderRepositoryImpl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'University Delivery App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const App(),
      ),
    );
  }
}
