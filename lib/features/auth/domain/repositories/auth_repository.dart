import 'package:maaakanmoney/features/auth/domain/entities/login_model.dart';

abstract class AuthRepository {
  Future<LogInModel> login(String mobileNumber, String password);
}
