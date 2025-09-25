import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/calculate_reading_time.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/screens/blog_viewer_screen.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (color == AppPallete.cardYellow || color == AppPallete.cardPurple) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerScreen.route(blog));
      },
      child: Container(
        margin: const EdgeInsets.all(16).copyWith(top: 0, bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOPICS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: blog.topics
                    .map(
                      (topic) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(
                            topic,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            // TITLE
            Text(
              blog.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            // READING TIME
            Row(
              children: [
                Icon(
                  Icons.timer_outlined, // A clean, modern clock icon
                  size: 18,
                  color: textColor,
                ),
                const SizedBox(width: 5), // A little space
                Text(
                  '${calculateReadingtime(blog.content)} min read',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
