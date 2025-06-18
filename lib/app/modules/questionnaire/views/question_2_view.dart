import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/questionnaire/controllers/questionnaire_controller.dart';

class Question2View extends GetView<QuestionnaireController> {
  const Question2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner 2', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                "https://forms.gle/R83Z9toN5DbNz1hT7",
              ),
            ),
            pullToRefreshController: controller.pullToRefreshController2,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController2 = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading2.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading2.value = false;
              controller.pullToRefreshController2.endRefreshing();
            },
          ),
          Obx(
                () =>
            controller.isLoading2.value
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
