import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_text_style.dart';

import '../controllers/questionnaire_controller.dart';

class QuestionnaireView extends GetView<QuestionnaireController> {
  const QuestionnaireView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuesioner', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.menuList.length,
          itemBuilder: (context, index) {
            final itemMenu = controller.menuList[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(itemMenu['route']);
                },
                child: ListTile(
                  title: Text(itemMenu['title'], style: AppTextStyle.headingSmall1),
                  subtitle: Text(itemMenu['subtitle'], style: AppTextStyle.bodyMedium1),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
