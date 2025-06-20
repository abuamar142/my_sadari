import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  static const Color purple1 = Color(0xFFBB86FC);
  static const Color purple2 = Color(0xFF6200EE);
  static const Color purple3 = Color(0xFF3700B3);
  static const Color teal1 = Color(0xFF03DAC5);
  static const Color teal2 = Color(0xFF018786);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pink = Color(0xFFE73A70);
  static const Color blue1 = Color(0xFF95b9d0);
  static const Color blue2 = Color(0xFFc9b3ef);
  static const Color orange = Color(0xFFFCBF4A);
  static const Color red = Color(0xFFFF0000);

  static const LinearGradient background1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [pink, white],
  );

  static const LinearGradient background2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue2, blue2],
  );

  static const LinearGradient background3 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [teal1, white],
  );
}
