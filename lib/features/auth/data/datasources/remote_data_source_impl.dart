/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maakan_money/features/auth/data/datasources/remote_data_source.dart';
import 'package:maakan_money/features/auth/domain/entities/login_model.dart';


class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<LogInModel> login(String username, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }
}
*/
