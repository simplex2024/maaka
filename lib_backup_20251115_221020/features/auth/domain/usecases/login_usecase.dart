import 'package:maaakanmoney/features/auth/domain/entities/login_model.dart';
import 'package:maaakanmoney/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LogInModel> call(String username, String password) {
    return repository.login(username, password);
  }
}
