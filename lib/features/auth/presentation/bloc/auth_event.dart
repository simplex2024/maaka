abstract class AuthEvent {
  const AuthEvent();
}

class AuthPhoneChanged extends AuthEvent {
  const AuthPhoneChanged(this.phoneNumber);

  final String phoneNumber;
}

class AuthOtpRequested extends AuthEvent {
  const AuthOtpRequested();
}
