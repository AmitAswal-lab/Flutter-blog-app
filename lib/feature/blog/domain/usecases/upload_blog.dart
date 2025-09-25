import 'dart:io';

import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/core/usecase/usecase.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String title;
  final String content;
  final String posterId;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.title,
    required this.content,
    required this.posterId,
    required this.image,
    required this.topics,
  });
}
