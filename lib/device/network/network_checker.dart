import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();
  final Connectivity _connectivity = Connectivity();
  void connectivityStream(Function(bool isOnline) eventCallBack) {
    _connectivity.onConnectivityChanged.listen(
      (event) {
        if (!event.contains(ConnectivityResult.none)) {
          eventCallBack.call(true);
        } else {
          eventCallBack.call(false);
        }
      },
    );
  }

  @override
  Future<bool> get isConnected async =>
      Future.value(!(await _connectivity.checkConnectivity())
          .contains(ConnectivityResult.none));
}
