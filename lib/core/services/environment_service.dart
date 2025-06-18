import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class EnvironmentService extends GetxService {
  late String appTitle;
  late String baseUrl;
  late bool enableLogging;
  late bool showDebugBanner;

  Future<EnvironmentService> init(String environment) async {
    switch (environment) {
      case 'dev':
        appTitle = 'MyApp Dev';
        showDebugBanner = false;
        baseUrl = 'https://api-kobessah.biscuit.my.id/';
        enableLogging = true;
        break;
      case 'stag':
        appTitle = 'MyApp Stag';
        showDebugBanner = false;
        baseUrl = 'https://api-kobessah.biscuit.my.id/';
        enableLogging = true;
        break;
      case 'prod':
        appTitle = 'MyApp';
        showDebugBanner = false;
        baseUrl = 'https://api-kobessah.biscuit.my.id/';
        enableLogging = false;
        break;
      default:
        throw Exception('Environment tidak valid!');
    }
    return this;
  }
}
