import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_colors.dart';

class NewsController extends GetxController {
  late InAppWebViewController? webController;

  final isLoading = true.obs;
  final selectedUrl = ''.obs;
  final selectedSourceTitle = ''.obs;

  late PullToRefreshController pullToRefreshController;

  @override
  void onInit() {
    super.onInit();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.blue2),
      onRefresh: () async {
        if (webController != null) {
          webController!.reload();
        }
      },
    );
  }

  /// Load URL in web view
  void loadUrl(String url, {String? sourceTitle}) {
    selectedUrl.value = url;
    selectedSourceTitle.value = sourceTitle ?? 'Sumber Berita';
    isLoading.value = true;
  }

  /// Go back to source selection
  void backToSourceSelection() {
    selectedUrl.value = '';
    selectedSourceTitle.value = '';
    webController = null;
  }

  /// Get source title for current URL
  String getSourceTitle() {
    if (selectedSourceTitle.value.isNotEmpty) {
      return selectedSourceTitle.value;
    }

    if (selectedUrl.value.contains('kemkes.go.id')) {
      return 'Kementerian Kesehatan';
    } else if (selectedUrl.value.contains('suara.com')) {
      return 'Suara.com';
    } else if (selectedUrl.value.contains('mediaindonesia.com')) {
      return 'Media Indonesia';
    } else if (selectedUrl.value.contains('sehatnegeriku.kemkes.go.id')) {
      return 'Sehat Negeriku';
    } else if (selectedUrl.value.contains('sindonews.com')) {
      return 'Sindo News';
    }

    return 'Sumber Berita';
  }
}
