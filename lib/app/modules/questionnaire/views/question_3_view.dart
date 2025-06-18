import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/questionnaire/controllers/questionnaire_controller.dart';

class Question3View extends GetView<QuestionnaireController> {
  const Question3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner 3', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://forms.gle/8JdCDihfYJjvfPYp6"),
            ),
            pullToRefreshController: controller.pullToRefreshController3,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController3 = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading3.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading3.value = false;
              controller.pullToRefreshController3.endRefreshing();
            },
          ),
          Obx(
            () =>
                controller.isLoading3.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
