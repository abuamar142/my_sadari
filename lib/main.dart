import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'core/services/environment_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  if (!['dev', 'stag', 'prod'].contains(environment)) {
    throw Exception('Environment not valid: $environment');
  }

  try {
    await Get.putAsync<EnvironmentService>(
      () => EnvironmentService().init(environment),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing environment: $e');
    }
    await Get.putAsync<EnvironmentService>(
      () => EnvironmentService().init('dev'),
    );
  }

  final EnvironmentService envService = Get.find();
  await initHiveForFlutter();
  await GetStorage.init();

  // Initialize NotificationService
  await Get.putAsync<NotificationService>(() async {
    final service = NotificationService();
    await service.onInit();
    return service;
  });

  Get.put(AuthController());

  final box = GetStorage();
  final cache = GraphQLCache();
  final String initialRoute =
      box.read('token') != null ? AppPages.initial : Routes.home;

  runApp(
    GraphQLProvider(
      client: ValueNotifier(
        GraphQLClient(link: HttpLink(envService.baseUrl), cache: cache),
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: envService.showDebugBanner,
        title: envService.appTitle,
        initialRoute: initialRoute,
        getPages: AppPages.routes,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id', 'ID')],
      ),
    ),
  );
}
