import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/utils/app_images.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(),

              // Main Content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(AppDimensions.paddingLarge),
                  children: [
                    // Welcome Card
                    _buildWelcomeCard(),

                    SizedBox(height: 20),

                    // Menu Section
                    _buildMenuSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
        endDrawer: _buildDrawer(),
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Konfirmasi Logout',
          style: AppTextStyle.headingMedium1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: AppTextStyle.bodyMedium1.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: AppTextStyle.bodyMedium1.copyWith(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.logout(); // Perform logout
            },
            child: Text(
              'Logout',
              style: AppTextStyle.bodyMedium1.copyWith(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build custom app bar
  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang! 👋',
                  style: AppTextStyle.headingLarge2.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.userName,
                    style: AppTextStyle.bodyLarge2.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build welcome card with health tips
  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Icon(Icons.favorite, color: AppColors.pink, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kesehatan Payudara Anda',
                      style: AppTextStyle.headingMedium1.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jaga kesehatan dengan pemeriksaan rutin',
                      style: AppTextStyle.bodyMedium1.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.pink.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: AppColors.pink.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.pink, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lakukan SADARI setiap bulan untuk deteksi dini',
                    style: AppTextStyle.bodyMedium1.copyWith(
                      fontSize: 13,
                      color: AppColors.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build menu section
  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildMenuList()],
    );
  }

  /// Build menu grid
  Widget _buildMenuList() {
    return Column(
      children: [
        _buildMenuListItem(
          title: 'SKRINING FAKTOR RISIKO',
          subtitle: 'Cek faktor risiko Anda',
          image: AppImages.menu1,
          color: AppColors.teal1,
          onTap: () => Get.toNamed(Routes.screening),
        ),
        SizedBox(height: 16),
        _buildMenuListItem(
          title: 'CARA SADARI',
          subtitle: 'Pelajari teknik pemeriksaan',
          image: AppImages.menu2,
          color: AppColors.orange,
          onTap: () => Get.toNamed(Routes.tutorial),
        ),
        SizedBox(height: 16),
        _buildMenuListItem(
          title: 'JADWAL SADARI',
          subtitle: 'Atur pengingat pemeriksaan',
          image: AppImages.menu3,
          color: AppColors.purple1,
          onTap: () => Get.toNamed(Routes.schedule),
        ),
        SizedBox(height: 16),
        _buildMenuListItem(
          title: 'INFO PENTING',
          subtitle: 'Artikel & berita kesehatan',
          image: AppImages.menu4,
          color: AppColors.teal2,
          onTap: () => Get.toNamed(Routes.news),
        ),
      ],
    );
  }

  /// Build individual menu list item
  Widget _buildMenuListItem({
    required String title,
    required String subtitle,
    required String image,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(image, width: 60, height: 60),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodyLarge2.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodySmall2.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build drawer
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.pink),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.white,
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                        color: AppColors.pink,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => Text(
                        controller.userName,
                        style: AppTextStyle.headingMedium2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.userEmail,
                        style: AppTextStyle.bodyMedium2.copyWith(
                          fontSize: 14,
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  icon: Icons.quiz_outlined,
                  title: "Kuisioner",
                  onTap: () => Get.toNamed(Routes.questionnaire),
                ),
                _buildDrawerItem(
                  icon: Icons.schedule_outlined,
                  title: "Jadwal SADARI",
                  onTap: () => Get.toNamed(Routes.schedule),
                ),
                _buildDrawerItem(
                  icon: Icons.history_outlined,
                  title: "Riwayat Periksa",
                  onTap: () => Get.toNamed(Routes.history),
                ),
                // _buildDrawerItem(
                //   icon: Icons.notifications_outlined,
                //   title: "Notifikasi",
                //   onTap: () => Get.toNamed(Routes.notification),
                // ),
                Divider(height: 32),

                // Debug menu (if in debug mode)
                if (kDebugMode) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Debug Menu',
                      style: AppTextStyle.bodySmall1.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.login_outlined,
                    title: "Sign In",
                    onTap: () => Get.toNamed(Routes.signIn),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_add_outlined,
                    title: "Sign Up",
                    onTap: () => Get.toNamed(Routes.signUp),
                  ),
                  _buildDrawerItem(
                    icon: Icons.refresh_outlined,
                    title: "Splash Screen",
                    onTap: () => Get.toNamed(Routes.splash),
                  ),
                  // _buildDrawerItem(
                  //   icon: Icons.start_outlined,
                  //   title: "Onboarding",
                  //   onTap: () => Get.toNamed(Routes.onboarding),
                  // ),
                  Divider(height: 32),
                ],

                // Logout
                Obx(
                  () =>
                      controller.isLoggedIn
                          ? _buildDrawerItem(
                            icon: Icons.logout_outlined,
                            title: "Logout",
                            onTap: () {
                              Get.back();
                              _showLogoutConfirmation();
                            },
                            textColor: Colors.red,
                            iconColor: Colors.red,
                          )
                          : SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[600], size: 24),
      title: Text(
        title,
        style: AppTextStyle.bodyMedium1.copyWith(
          fontSize: 15,
          color: textColor ?? Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
