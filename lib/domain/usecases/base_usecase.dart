/// Base class for all use cases
///
/// This abstract class defines the contract for use cases in the domain layer.
/// All use cases should extend this class and implement the call method.
abstract class UseCase<Type, Params> {
  /// Execute the use case with the given parameters
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class UseCaseNoParams<Type> {
  /// Execute the use case without parameters
  Future<Type> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
