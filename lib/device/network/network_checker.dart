import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();
  @override
  Future<bool> get isConnected async =>
      Future.value(!(await Connectivity().checkConnectivity())
          .contains(ConnectivityResult.none));
}
