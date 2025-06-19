import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/modules/home/views/menu_widget.dart';
import 'package:my_sadari/app/styles/app_colors.dart';
import 'package:my_sadari/app/utils/app_images.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              children: [
                TextSpan(text: 'Selamat Datang\n'),
                TextSpan(
                  text: 'Sahabat SADARI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu),
                  color: AppColors.white,
                  iconSize: 28,
                );
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Sahabat SADARI"),
                accountEmail: Text("beta_sadari@example.com"),
                currentAccountPicture: CircleAvatar(
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 72,
                    color: AppColors.pink,
                  ),
                ),
                decoration: BoxDecoration(color: AppColors.pink),
              ),
              ListTile(
                leading: Icon(Icons.question_mark_rounded),
                title: Text("Kuisioner"),
                onTap: () => Get.toNamed(Routes.questionnaire),
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text("Jadwal SADARI"),
                onTap: () => Get.toNamed(Routes.schedule),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("Riwayat Periksa"),
                onTap: () => Get.toNamed(Routes.history),
              ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text("Sign In"),
                onTap: () => Get.toNamed(Routes.signIn),
              ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text("Sign Up"),
                onTap: () => Get.toNamed(Routes.signUp),
              ),
              ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text("Notifikasi"),
                onTap: () => Get.toNamed(Routes.notification),
              ),
              ListTile(
                leading: Icon(Icons.start),
                title: Text("Onboarding"),
                onTap: () => Get.toNamed(Routes.onboarding),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(padding: EdgeInsets.all(20), children: [_menu()]),
        ),
      ),
    );
  }

  // Widget _greeting() {
  //   return
  // }

  Widget _menu() {
    return Column(
      children: [
        MenuWidget(
          title: 'SKRENING\nFAKTOR\nRESIKO',
          image: AppImages.menu1,
          route: () => Get.toNamed(Routes.screening),
          color: AppColors.teal1,
        ),
        SizedBox(height: 20),
        MenuWidget(
          title: 'CARA\nPEMERIKSAAN\nSADARI',
          image: AppImages.menu2,
          route: () => Get.toNamed(Routes.tutorial),
          color: AppColors.orange,
        ),
        SizedBox(height: 20),
        MenuWidget(
          title: 'JADWAL\nSADARI',
          image: AppImages.menu3,
          route: () => Get.toNamed(Routes.schedule),
          color: AppColors.blue2,
        ),
        SizedBox(height: 20),
        MenuWidget(
          title: 'INFO\nPENTING',
          image: AppImages.menu4,
          route: () => Get.toNamed(Routes.news),
          color: AppColors.teal1,
        ),
      ],
    );
  }
}
