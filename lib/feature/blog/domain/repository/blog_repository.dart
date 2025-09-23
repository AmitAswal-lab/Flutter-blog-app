import 'dart:io';

import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure,Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
}
