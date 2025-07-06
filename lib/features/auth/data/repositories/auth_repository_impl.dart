import 'package:maaakanmoney/features/auth/data/datasources/remote_data_source.dart';
import 'package:maaakanmoney/features/auth/domain/entities/login_model.dart';
import 'package:maaakanmoney/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LogInModel> login(String mobilePassword, String password) async {
    final userModel = await remoteDataSource.login(mobilePassword, password);
    return userModel;
  }
}
