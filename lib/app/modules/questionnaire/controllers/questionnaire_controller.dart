import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';

class QuestionnaireController extends GetxController {
  late InAppWebViewController webController1;
  late InAppWebViewController webController2;
  late InAppWebViewController webController3;
  late InAppWebViewController webController4;
  late InAppWebViewController webController5;

  final isLoading1 = true.obs;
  final isLoading2 = true.obs;
  final isLoading3 = true.obs;
  final isLoading4 = true.obs;
  final isLoading5 = true.obs;

  late PullToRefreshController pullToRefreshController1;
  late PullToRefreshController pullToRefreshController2;
  late PullToRefreshController pullToRefreshController3;
  late PullToRefreshController pullToRefreshController4;
  late PullToRefreshController pullToRefreshController5;

  @override
  void onInit() {
    super.onInit();

    pullToRefreshController1 = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.purple3),
      onRefresh: () async {
        webController1.reload();
      },
    );
    pullToRefreshController2 = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.purple3),
      onRefresh: () async {
        webController2.reload();
      },
    );
    pullToRefreshController3 = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.purple3),
      onRefresh: () async {
        webController3.reload();
      },
    );
    pullToRefreshController4 = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.purple3),
      onRefresh: () async {
        webController4.reload();
      },
    );
    pullToRefreshController5 = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.purple3),
      onRefresh: () async {
        webController5.reload();
      },
    );
  }

  RxList<Map<String, dynamic>> menuList =
      [
        {
          'title': 'Kuesioner 1',
          'subtitle': 'Kuesioner Karakteristik Demografi',
          'route': Routes.question1,
        },
        {
          'title': 'Kuesioner 2',
          'subtitle': 'Kuesioner Sumber Informasi Tentang Kanker Payudara dan SADARI',
          'route': Routes.question2,
        },
        {
          'title': 'Kuesioner 3',
          'subtitle': 'Kuesioner Pengetahuan Tentang Kanker Payudara',
          'route': Routes.question3,
        },
        {
          'title': 'Kuesioner 4',
          'subtitle': 'Kuesioner Sikap',
          'route': Routes.question4,
        },
        {
          'title': 'Kuesioner 5',
          'subtitle': 'Kuesioner Pelaksanaan SADARI',
          'route': Routes.question5,
        },
      ].obs;
}
