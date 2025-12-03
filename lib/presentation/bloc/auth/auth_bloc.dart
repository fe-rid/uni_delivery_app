import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_delivery_app/domain/repositories/auth_repository.dart';
import 'package:university_delivery_app/presentation/bloc/auth/auth_event.dart';
import 'package:university_delivery_app/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithAppleEvent>(_onLoginWithApple);

    // Listen to auth state changes (only if Firebase is initialized)
    try {
      authRepository.authStateChanges().listen(
        (user) {
          if (user != null) {
            add(const CheckAuthStatusEvent());
          } else {
            add(const LogoutEvent());
          }
        },
        onError: (error) {
          // Firebase not initialized - emit unauthenticated state
          add(const LogoutEvent());
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Firebase not available - start in unauthenticated state
      // Don't add event here, let CheckAuthStatusEvent handle it
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user, userRole: user.role));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // If Firebase is not initialized, just show login page
      if (e.toString().contains('no-app') || e.toString().contains('Firebase')) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.login(event.email, event.password)
          .timeout(
            const Duration(seconds: 45),
            onTimeout: () {
              throw Exception('Login timeout. Please check your internet connection and try again.');
            },
          );
      emit(AuthAuthenticated(user: user, userRole: user.role));
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      } else if (errorMessage.startsWith('Exception:')) {
        errorMessage = errorMessage.substring(10).trim();
      }
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        role: event.role,
      );
      emit(AuthAuthenticated(user: user, userRole: user.role));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.loginWithGoogle();
      emit(AuthAuthenticated(user: user, userRole: user.role));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithApple(
    LoginWithAppleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.loginWithApple();
      emit(AuthAuthenticated(user: user, userRole: user.role));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

