import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/news_controller.dart';

class NewsDetailView extends GetView<NewsController> {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from previous screen
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String url = args['url'] ?? '';
    final String title = args['title'] ?? 'Berita';
    final Color sourceColor = args['color'] ?? AppColors.teal2;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [sourceColor.withValues(alpha: 0.1), AppColors.white],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: sourceColor),
          title: Text(
            title,
            style: AppTextStyle.headingLarge2.copyWith(
              fontWeight: FontWeight.bold,
              color: sourceColor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: sourceColor, size: 20),
              onPressed: () {
                if (controller.webController != null) {
                  controller.webController!.reload();
                }
              },
            ),
          ],
        ),
        body: SafeArea(child: _buildWebView(url, sourceColor)),
      ),
    );
  }

  Widget _buildWebView(String url, Color sourceColor) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            javaScriptEnabled: true,
            supportZoom: true,
            builtInZoomControls: false,
            displayZoomControls: false,
            userAgent:
                "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
          ),
          onWebViewCreated: (InAppWebViewController webViewController) {
            controller.webController = webViewController;
          },
          onLoadStart: (InAppWebViewController webViewController, WebUri? url) {
            controller.isLoading.value = true;
          },
          onLoadStop: (
            InAppWebViewController webViewController,
            WebUri? url,
          ) async {
            controller.isLoading.value = false;
            controller.pullToRefreshController.endRefreshing();
          },
          onReceivedError: (
            InAppWebViewController webViewController,
            WebResourceRequest request,
            WebResourceError error,
          ) {
            controller.isLoading.value = false;
            controller.pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (
            InAppWebViewController webViewController,
            int progress,
          ) {
            // Optional: You can add a progress bar here if needed
          },
        ),

        // Loading Overlay
        Obx(
          () =>
              controller.isLoading.value
                  ? Container(
                    color: AppColors.white.withValues(alpha: 0.9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: sourceColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLarge,
                              ),
                            ),
                            child: CircularProgressIndicator(
                              color: sourceColor,
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Memuat artikel...',
                            style: AppTextStyle.bodyMedium1.copyWith(
                              color: sourceColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mohon tunggu sebentar',
                            style: AppTextStyle.bodySmall1.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),

        // Error State (Optional)
        Obx(
          () =>
              !controller.isLoading.value && url.isEmpty
                  ? Container(
                    color: AppColors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak dapat memuat halaman',
                            style: AppTextStyle.bodyLarge1.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Periksa koneksi internet Anda',
                            style: AppTextStyle.bodyMedium1.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.arrow_back, size: 18),
                            label: Text('Kembali'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sourceColor,
                              foregroundColor: AppColors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
