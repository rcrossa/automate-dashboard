abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexión']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Error de autenticación']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Error de validación']);
}
