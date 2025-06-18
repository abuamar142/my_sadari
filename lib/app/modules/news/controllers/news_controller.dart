import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_colors.dart';

class NewsController extends GetxController {
  late InAppWebViewController? webController;

  final isLoading = true.obs;

  late PullToRefreshController pullToRefreshController;

  @override
  void onInit() {
    super.onInit();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.blue2),
      onRefresh: () async {
        webController!.reload();
      },
    );
  }
}
