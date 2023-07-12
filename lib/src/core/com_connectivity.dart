import 'dart:async';
import 'dart:io';
import 'package:api_com/api_com.dart';

class ComConnectivity {
  ComConnectivity(this.config) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final result = await isInternetAvailable();
        _controller.add(result);
      } catch (e) {
        _controller.add(false);
      }
    });
  }

  late final Timer _timer;

  final ComConfig config;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _controller.stream;

  Future<bool> isInternetAvailable() async {
    try {
      await InternetAddress.lookup(config.getUrl());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> dispose() async {
    _timer.cancel();
    await _controller.close();
  }
}
