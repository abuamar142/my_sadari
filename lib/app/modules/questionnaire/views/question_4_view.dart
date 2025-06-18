import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/questionnaire/controllers/questionnaire_controller.dart';

class Question4View extends GetView<QuestionnaireController> {
  const Question4View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner 4', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://forms.gle/qAk2s2RJTL9ep6tv5"),
            ),
            pullToRefreshController: controller.pullToRefreshController4,
            onWebViewCreated: (InAppWebViewController webController) {
              controller.webController4 = webController;
            },
            onLoadStart: (InAppWebViewController webController, WebUri? url) {
              controller.isLoading4.value = true;
            },
            onLoadStop: (InAppWebViewController webController, WebUri? url) async {
              controller.isLoading4.value = false;
              controller.pullToRefreshController4.endRefreshing();
            },
          ),
          Obx(
            () =>
                controller.isLoading4.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
