/*
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaakanmoney/core/network/bloc/connectivity_event.dart';
import 'package:maaakanmoney/core/network/bloc/connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription _connectivitySubscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityStatusChanged>(_onStatusChanged);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
          add(ConnectivityStatusChanged(result));
        });
  }

  Future<void> _onCheckConnectivity(
      CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    final result = await _connectivity.checkConnectivity();
    add(ConnectivityStatusChanged(result));
  }

  void _onStatusChanged(
      ConnectivityStatusChanged event, Emitter<ConnectivityState> emit) {
    if (event.result == ConnectivityResult.none) {
      emit(ConnectivityOffline());
    } else {
      emit(ConnectivityOnline(event.result));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
*/
