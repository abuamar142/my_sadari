import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/questionnaire/controllers/questionnaire_controller.dart';

class Question5View extends GetView<QuestionnaireController> {
  const Question5View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner 5', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://forms.gle/f5Z1duPPgByWFBdX7"),
            ),
            pullToRefreshController: controller.pullToRefreshController5,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController5 = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading5.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading5.value = false;
              controller.pullToRefreshController5.endRefreshing();
            },
          ),
          Obx(
            () =>
                controller.isLoading5.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
