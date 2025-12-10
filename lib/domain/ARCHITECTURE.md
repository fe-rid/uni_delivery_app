# Domain Layer Architecture

This document describes the Clean Architecture structure of the domain layer.

## Structure

```
lib/domain/
├── entities/          # Business entities (pure Dart classes)
├── repositories/      # Repository interfaces (contracts)
└── usecases/          # Use cases (business logic)
    ├── auth/         # Authentication use cases
    ├── restaurant/   # Restaurant use cases
    ├── menu/         # Menu use cases
    └── order/        # Order use cases
```

## Components

### 1. Entities
Pure business objects that represent core business concepts. They contain no framework-specific code and are independent of data sources.

**Files:**
- `user_entity.dart`
- `restaurant_entity.dart`
- `menu_item_entity.dart`
- `cart_item_entity.dart`
- `order_entity.dart`

### 2. Repositories (Interfaces)
Abstract contracts that define what data operations are needed. Implementations are in the data layer.

**Files:**
- `auth_repository.dart`
- `restaurant_repository.dart`
- `menu_repository.dart`
- `order_repository.dart`

### 3. Use Cases
Encapsulate business logic and orchestrate repository calls. Each use case represents a single business operation.

#### Base Use Case
- `base_usecase.dart` - Base classes for all use cases

#### Auth Use Cases
- `login_usecase.dart` - User login
- `register_usecase.dart` - User registration
- `logout_usecase.dart` - User logout
- `get_current_user_usecase.dart` - Get current authenticated user
- `login_with_google_usecase.dart` - Google sign-in
- `login_with_apple_usecase.dart` - Apple sign-in

#### Restaurant Use Cases
- `get_restaurants_usecase.dart` - Get all restaurants
- `get_restaurant_by_id_usecase.dart` - Get restaurant by ID

#### Menu Use Cases
- `get_menu_items_usecase.dart` - Get menu items for a restaurant
- `get_menu_item_by_id_usecase.dart` - Get menu item by ID

#### Order Use Cases
- `create_order_usecase.dart` - Create a new order
- `get_orders_by_user_usecase.dart` - Get orders by user ID
- `get_orders_by_runner_usecase.dart` - Get orders by runner ID
- `get_pending_orders_usecase.dart` - Get pending orders
- `get_order_by_id_usecase.dart` - Get order by ID
- `update_order_status_usecase.dart` - Update order status

## Usage Example

### In BLoC (Presentation Layer)

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await loginUseCase(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
```

### Dependency Injection

```dart
// In your dependency injection setup
final authRepository = AuthRepositoryImpl(...);

final loginUseCase = LoginUseCase(authRepository);
final registerUseCase = RegisterUseCase(authRepository);
final logoutUseCase = LogoutUseCase(authRepository);

// Provide to BLoC
AuthBloc(
  loginUseCase: loginUseCase,
  registerUseCase: registerUseCase,
  logoutUseCase: logoutUseCase,
)
```

## Clean Architecture Principles

1. **Dependency Rule**: Dependencies point inward
   - Domain layer has no dependencies on outer layers
   - Presentation and Data layers depend on Domain layer

2. **Separation of Concerns**:
   - Entities: Pure business objects
   - Repositories: Data access contracts
   - Use Cases: Business logic orchestration

3. **Single Responsibility**:
   - Each use case handles one specific business operation
   - Easy to test and maintain

4. **Testability**:
   - Use cases can be tested independently
   - Mock repositories easily for unit tests

## Benefits

- ✅ **Clean separation** of business logic from UI and data
- ✅ **Testable** - Easy to unit test use cases
- ✅ **Maintainable** - Clear structure and responsibilities
- ✅ **Scalable** - Easy to add new features
- ✅ **Framework independent** - Domain logic doesn't depend on Flutter/Firebase

