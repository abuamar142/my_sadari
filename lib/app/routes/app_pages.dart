import 'package:get/get.dart';

import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/news/bindings/news_binding.dart';
import '../modules/news/views/news_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/questionnaire/bindings/questionnaire_binding.dart';
import '../modules/questionnaire/views/question_1_view.dart';
import '../modules/questionnaire/views/question_2_view.dart';
import '../modules/questionnaire/views/question_3_view.dart';
import '../modules/questionnaire/views/question_4_view.dart';
import '../modules/questionnaire/views/question_5_view.dart';
import '../modules/questionnaire/views/questionnaire_view.dart';
import '../modules/schedule/bindings/schedule_binding.dart';
import '../modules/schedule/views/schedule_view.dart';
import '../modules/screening/bindings/screening_binding.dart';
import '../modules/screening/views/screening_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.screening,
      page: () => const ScreeningView(),
      binding: ScreeningBinding(),
    ),
    GetPage(
      name: _Paths.tutorial,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.schedule,
      page: () => const ScheduleView(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: _Paths.news,
      page: () => const NewsView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.history,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.questionnaire,
      page: () => const QuestionnaireView(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.question1,
      page: () => const Question1View(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.question2,
      page: () => const Question2View(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.question3,
      page: () => const Question3View(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.question4,
      page: () => const Question4View(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.question5,
      page: () => const Question5View(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: _Paths.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
  ];
}
