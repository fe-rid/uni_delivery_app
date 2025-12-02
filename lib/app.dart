import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:university_delivery_app/presentation/pages/auth/login_page.dart';
import 'package:university_delivery_app/presentation/pages/auth/splash_page.dart';
import 'package:university_delivery_app/presentation/pages/home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashPage();
        } else if (state is AuthAuthenticated) {
          return HomePage(userRole: state.userRole);
        } else if (state is AuthUnauthenticated) {
          return const LoginPage();
        } else {
          return const SplashPage();
        }
      },
    );
  }
}

