import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get isOnline$ => _connectivity.onConnectivityChanged
      .map((results) => _isOnline(results));

  Future<bool> get isCurrentlyOnline async {
    final results = await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
