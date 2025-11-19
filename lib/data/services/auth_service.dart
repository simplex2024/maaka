import 'dart:async';
import 'dart:math';

import '../models/auth_models.dart';

class AuthService {
  Future<OtpResponse> sendOtp(OtpRequest request) async {
    // TODO: Replace mock delay + random OTP with a real API call.
    // Example:
    // final response = await http.post('$baseUrl/otp', body: {...});
    // return OtpResponse.fromJson(response.data);
    await Future.delayed(const Duration(seconds: 2));

    final digitsOnly = request.phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      throw const AuthException('Invalid phone number');
    }

    // Generate a 4-digit mock OTP to match the UI design
    final randomOtp = (Random().nextInt(9000) + 1000).toString();
    return OtpResponse(
      phoneNumber: digitsOnly,
      otp: randomOtp,
      message: 'OTP sent successfully',
    );
  }

  Future<bool> verifyOtp(VerifyOtpRequest request) async {
    // TODO: Replace with actual verify endpoint call.
    // Example:
    // final response = await http.post('$baseUrl/otp/verify', body: {...});
    // return response.isSuccess;
    await Future.delayed(const Duration(milliseconds: 800));
    if (request.enteredOtp == request.expectedOtp) {
      return true;
    }
    throw const AuthException('Incorrect code, please try again.');
  }
}

