import 'package:connectivity/connectivity.dart';

class CheckConnection {
  Future<String> checkNetworkConnection() async {
    try {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return "0";
      } else {
        return "1";
      }
    } catch (error) {
      return error.toString();
    }
  }
}
