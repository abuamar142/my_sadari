import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class EnvironmentService extends GetxService {
  late String appTitle;
  late String baseUrl;
  late bool enableLogging;
  late bool showDebugBanner;

  Future<EnvironmentService> init(String environment) async {
    switch (environment) {
      case 'dev':
        appTitle = 'SADARI Dev';
        showDebugBanner = false;
        baseUrl = 'https://sadari.sdnusabali.online';
        enableLogging = true;
        break;
      case 'stag':
        appTitle = 'SADARI Stag';
        showDebugBanner = false;
        baseUrl = 'https://sadari.sdnusabali.online';
        enableLogging = true;
        break;
      case 'prod':
        appTitle = 'SADARI';
        showDebugBanner = false;
        baseUrl = 'https://sadari.sdnusabali.online';
        enableLogging = false;
        break;
      default:
        throw Exception('Environment tidak valid!');
    }
    return this;
  }
}
