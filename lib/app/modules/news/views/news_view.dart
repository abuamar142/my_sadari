import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/news_source_model.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../../../widgets/app_card_info.dart';
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

            SizedBox(height: 20),

            // News Sources List
            ...controller.newsSources.map(
              (source) => _buildNewsSourceItem(source: source),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSourceItem({required NewsSourceModel source}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => Get.toNamed(
                Routes.newsDetail,
                arguments: {
                  'url': source.url,
                  'title': source.title,
                  'color': source.color,
                },
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
                    color: source.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(source.icon, size: 20, color: source.color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.title,
                        style: AppTextStyle.bodyMedium1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        source.subtitle,
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
