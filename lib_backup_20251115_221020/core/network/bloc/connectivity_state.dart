import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityOnline extends ConnectivityState {
  final ConnectivityResult result;
  ConnectivityOnline(this.result);
}

class ConnectivityOffline extends ConnectivityState {}
