import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/widgets/app_card_info.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background4),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Info Penting',
            style: AppTextStyle.headingLarge2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
          centerTitle: true,
        ),
        body: _buildSourceSelection(),
      ),
    );
  }

  Widget _buildSourceSelection() {
    final newsSourceList = [
      {
        'title': 'Kementerian Kesehatan',
        'subtitle': 'Portal resmi informasi kesehatan',
        'url': 'https://kemkes.go.id/id/search?s=payudara',
        'icon': Icons.local_hospital,
        'color': AppColors.pink,
      },
      {
        'title': 'Suara.com',
        'subtitle': 'Berita terpercaya seputar kesehatan',
        'url': 'https://www.suara.com/search?q=payudara',
        'icon': Icons.newspaper,
        'color': AppColors.teal2,
      },
      {
        'title': 'Media Indonesia',
        'subtitle': 'Portal berita nasional',
        'url': 'https://mediaindonesia.com/',
        'icon': Icons.article,
        'color': AppColors.orange,
      },
      {
        'title': 'Sehat Negeriku',
        'subtitle': 'Informasi kesehatan terpercaya',
        'url': 'https://sehatnegeriku.kemkes.go.id/?s=payudara',
        'icon': Icons.health_and_safety,
        'color': AppColors.purple1,
      },
      {
        'title': 'Sindo News',
        'subtitle': 'Artikel kesehatan terkini',
        'url': 'https://search.sindonews.com/go?q=payudara&type=artikel',
        'icon': Icons.feed,
        'color': AppColors.blue1,
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            AppCardInfo(
              title: 'Pilih Sumber Berita',
              subtitle:
                  'Dapatkan informasi kesehatan payudara dari berbagai sumber terpercaya',
              color: AppColors.teal2,
              icon: Icons.health_and_safety_outlined,
            ),

            SizedBox(height: 20), // News Sources List
            ...newsSourceList.map(
              (source) => _buildNewsSourceItem(
                title: source['title'] as String,
                subtitle: source['subtitle'] as String,
                url: source['url'] as String,
                icon: source['icon'] as IconData,
                color: source['color'] as Color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSourceItem({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => Get.toNamed(
                Routes.newsDetail,
                arguments: {'url': url, 'title': title, 'color': color},
              ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.bodyMedium1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyle.bodySmall1.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
