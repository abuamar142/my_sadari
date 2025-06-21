import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../core/models/news_source_model.dart';
import '../../../styles/app_colors.dart';

class NewsController extends GetxController {
  late InAppWebViewController? webController;

  final isLoading = true.obs;
  final selectedUrl = ''.obs;
  final selectedSourceTitle = ''.obs;

  late PullToRefreshController pullToRefreshController;

  /// Get news sources data
  List<NewsSourceModel> get newsSources => [
    NewsSourceModel(
      title: 'Kementerian Kesehatan',
      subtitle: 'Portal resmi informasi kesehatan',
      url: 'https://kemkes.go.id/id/search?s=payudara',
      icon: Icons.local_hospital,
      color: AppColors.pink,
    ),
    NewsSourceModel(
      title: 'Suara.com',
      subtitle: 'Berita terpercaya seputar kesehatan',
      url: 'https://www.suara.com/search?q=payudara',
      icon: Icons.newspaper,
      color: AppColors.teal2,
    ),
    NewsSourceModel(
      title: 'Media Indonesia',
      subtitle: 'Portal berita nasional',
      url: 'https://mediaindonesia.com/',
      icon: Icons.article,
      color: AppColors.orange,
    ),
    NewsSourceModel(
      title: 'Sehat Negeriku',
      subtitle: 'Informasi kesehatan terpercaya',
      url: 'https://sehatnegeriku.kemkes.go.id/?s=payudara',
      icon: Icons.health_and_safety,
      color: AppColors.purple1,
    ),
    NewsSourceModel(
      title: 'Sindo News',
      subtitle: 'Artikel kesehatan terkini',
      url: 'https://search.sindonews.com/go?q=payudara&type=artikel',
      icon: Icons.feed,
      color: AppColors.blue1,
    ),
  ];

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

    // Find source by URL match
    for (final source in newsSources) {
      if (selectedUrl.value.contains(_extractDomain(source.url))) {
        return source.title;
      }
    }

    return 'Sumber Berita';
  }

  /// Extract domain from URL for matching
  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }
}
