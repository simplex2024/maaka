import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.phoneNumber = '',
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.generatedOtp,
  });

  final String phoneNumber;
  final AuthStatus status;
  final String? errorMessage;
  final String? generatedOtp;

  bool get isValidPhone => phoneNumber.replaceAll(RegExp(r'\D'), '').length == 10;

  AuthState copyWith({
    String? phoneNumber,
    AuthStatus? status,
    String? errorMessage,
    String? generatedOtp,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      errorMessage: errorMessage,
      generatedOtp: generatedOtp,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, status, errorMessage, generatedOtp];
}
