import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../utils/app_images.dart';
import '../controllers/home_controller.dart';
import 'menu_widget.dart';

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
              Obx(
                () => UserAccountsDrawerHeader(
                  accountName: Text(controller.userName),
                  accountEmail: Text(controller.userEmail),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 72,
                      color: AppColors.pink,
                    ),
                  ),
                  decoration: BoxDecoration(color: AppColors.pink),
                ),
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
              // Show login/logout options based on auth status
              Obx(
                () =>
                    controller.isLoggedIn
                        ? ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            Get.back(); // Close drawer first
                            _showLogoutConfirmation();
                          },
                        )
                        : Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.login),
                              title: Text("Sign In"),
                              onTap: () => Get.toNamed(Routes.signIn),
                            ),
                            ListTile(
                              leading: Icon(Icons.account_circle_outlined),
                              title: Text("Sign Up"),
                              onTap: () => Get.toNamed(Routes.signUp),
                            ),
                          ],
                        ),
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

  /// Show logout confirmation dialog
  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.logout(); // Perform logout
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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
