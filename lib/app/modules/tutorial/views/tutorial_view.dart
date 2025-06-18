import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/tutorial/views/tutorial_widget.dart';
import 'package:my_sadari/app/utils/app_images.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      appBar: AppBar(
        title: Text(
          'Cara Pemeriksaan Sadari',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        children: [_steps(), SizedBox(height: AppDimensions.paddingLarge), _warning()],
      ),
    );
  }

  Widget _steps() {
    return Column(
      children: [
        TutorialWidget(
          description:
              'Berdiri tegak di depan cermin dengan kedua tangan ke bawah di samping badan. Melihat dan membandingkan kedua payudara dalam bentuk, ukuran dan warna kulit.\n\nPerhatikan kemungkinan-kemungkinan berikut: Pembengkakan kulit, Posisi dan bentuk dari puting susu (apakah masuk ke dalam atau bengkak), Kulit kemerahan, keriput atau borok dan bengkak.',
          image: AppImages.tutor1,
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        TutorialWidget(
          description:
              'Berdiri dengan mengangkat kedua lengan dan melihat kelainan seperti pada langkah 1 di atas.',
          image: AppImages.tutor2,
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        TutorialWidget(
          description:
              'Perhatikan tanda-tanda adanya pengeluaran cairan dari puting susu.',
          image: AppImages.tutor3,
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        TutorialWidget(
          description:
              'Posisi berbaring, rabalah kedua payudara, payudara kiri dengan tangan kanan dan sebaliknya. Gunakan bagian dalam telapak tangan dari jari ke 2-4. Raba seluruh payudara dengan cara melingkar dari luar ke dalam atau dapat juga vertikal dari atas ke bawah.',
          image: AppImages.tutor4,
        ),
        SizedBox(height: AppDimensions.paddingLarge),
        TutorialWidget(
          description:
              'Saat mandi rabalah payudara dengan tangan yang licin karena sabun dalam posisi berdiri dan lakukan cara melingkar dari luar ke dalam atau dapat juga vertikal dari atas ke bawah.',
          image: AppImages.tutor5,
        ),
      ],
    );
  }

  Widget _warning() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.pink),
          SizedBox(height: 8),
          Text(
            textAlign: TextAlign.justify,
            "JIKA MENEMUKAN BENJOLAN ATAU PERBEDAAN PADA PAYUDARA YANG MEMBUAT ANDA RESAH, SEGERA KONSULTASIKAN KEPADA TENAGA KESEHATAN DI PUSKESMAS SETEMPAT.",
            style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
