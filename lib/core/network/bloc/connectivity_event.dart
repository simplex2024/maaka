import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityEvent {}

class CheckConnectivity extends ConnectivityEvent {}

class ConnectivityStatusChanged extends ConnectivityEvent {
  final ConnectivityResult result;
  ConnectivityStatusChanged(this.result);
}
