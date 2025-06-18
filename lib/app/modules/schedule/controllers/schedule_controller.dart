import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleController extends GetxController {
  final selectDate = DateTime.now().obs;
  final examDate = DateTime.now().add(Duration(days: 10)).obs;

  @override
  void onInit() {
    super.onInit();
    ever<DateTime>(selectDate, (d) {
      examDate.value = d.add(Duration(days: 10));
    });
  }

  String get formattedDate => DateFormat.yMMMMEEEEd('id_ID').format(selectDate.value);

  String get formattedExamDate => DateFormat.yMMMMEEEEd('id_ID').format(examDate.value);
}
