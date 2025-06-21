import 'package:flutter/material.dart';

class NewsSourceModel {
  final String title;
  final String subtitle;
  final String url;
  final IconData icon;
  final Color color;

  NewsSourceModel({
    required this.title,
    required this.subtitle,
    required this.url,
    required this.icon,
    required this.color,
  });
}