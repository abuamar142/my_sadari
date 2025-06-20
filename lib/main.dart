import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'app/routes/app_pages.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
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

  // Initialize API Service
  Get.put<ApiService>(ApiService());

  // Initialize Auth Service
  Get.put<AuthService>(AuthService());

  // Check if user is logged in by checking AuthService (only in production)
  final authService = Get.find<AuthService>();
  final String initialRoute =
      environment == 'prod'
          ? (authService.isLoggedIn ? '/home' : '/sign-in')
          : '/home'; // Dev and staging go directly to home

  final cache = GraphQLCache();

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
