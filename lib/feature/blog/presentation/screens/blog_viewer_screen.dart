import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/calculate_reading_time.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/format_date.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerScreen extends StatelessWidget {
  final Blog blog;
  const BlogViewerScreen({super.key, required this.blog});

  static route(Blog blog) =>
      MaterialPageRoute(builder: (ctx) => BlogViewerScreen(blog: blog));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                SizedBox(height: 8),
                Text(
                  '${formatDateByDMMMYYYYY(blog.updatedAt)} . ${calculateReadingtime(blog.content)} min read',
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  child: Image.network(blog.imageUrl),
                ),
                SizedBox(height: 20),
                Text(blog.content, style: TextStyle(fontSize: 15, height: 1.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
