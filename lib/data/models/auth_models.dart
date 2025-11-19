class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OtpRequest {
  const OtpRequest({required this.phoneNumber});

  final String phoneNumber;
}

class OtpResponse {
  const OtpResponse({
    required this.phoneNumber,
    required this.otp,
    required this.message,
  });

  final String phoneNumber;
  final String otp;
  final String message;
}

class VerifyOtpRequest {
  const VerifyOtpRequest({
    required this.phoneNumber,
    required this.enteredOtp,
    required this.expectedOtp,
  });

  final String phoneNumber;
  final String enteredOtp;
  final String expectedOtp;
}

