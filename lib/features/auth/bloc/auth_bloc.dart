import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/auth_models.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState()) {
    on<AuthPhoneChanged>(_onPhoneChanged);
    on<AuthOtpRequested>(_onOtpRequested);
  }

  final AuthRepository _repository;

  void _onPhoneChanged(AuthPhoneChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        status: AuthStatus.initial,
        errorMessage: null,
        generatedOtp: null,
      ),
    );
  }

  Future<void> _onOtpRequested(
    AuthOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isValidPhone) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Enter a valid 10-digit number',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
        generatedOtp: null,
      ),
    );

    try {
      final response = await _repository.requestOtp(state.phoneNumber);
      emit(
        state.copyWith(
          status: AuthStatus.success,
          generatedOtp: response.otp,
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
