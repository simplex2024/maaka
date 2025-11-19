import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<OtpResponse> requestOtp(String phoneNumber) {
    return _service.sendOtp(OtpRequest(phoneNumber: phoneNumber));
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String expectedOtp,
  }) {
    return _service.verifyOtp(
      VerifyOtpRequest(
        phoneNumber: phoneNumber,
        enteredOtp: otp,
        expectedOtp: expectedOtp,
      ),
    );
  }
}

