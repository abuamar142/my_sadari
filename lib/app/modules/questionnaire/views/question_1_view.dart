import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../controllers/questionnaire_controller.dart';

class Question1View extends GetView<QuestionnaireController> {
  const Question1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner 1', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                "https://forms.gle/UXzmAjwG2b98yRES9",
              ),
            ),
            pullToRefreshController: controller.pullToRefreshController1,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController1 = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading1.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading1.value = false;
              controller.pullToRefreshController1.endRefreshing();
            },
          ),
          Obx(
            () =>
                controller.isLoading1.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
