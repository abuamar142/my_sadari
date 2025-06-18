import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Penting', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://kemkes.go.id/id/search?s=payudara"),
            ),
            initialSettings: InAppWebViewSettings(),
            pullToRefreshController: controller.pullToRefreshController,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading.value = false;
              controller.pullToRefreshController.endRefreshing();
            },
            // onLoadError: (InAppWebViewController webController, WebUri? url, int code, String message) {
            //   controller.isLoading.value = false;
            //   controller.pullToRefreshController.endRefreshing();
            // },
          ),
          Obx(
            () =>
                controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
