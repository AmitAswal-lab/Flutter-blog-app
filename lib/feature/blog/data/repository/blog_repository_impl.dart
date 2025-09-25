import 'dart:io';

import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/datasources/blog_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/models/blog_model.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;
  BlogRepositoryImpl(this.blogRemoteDatasource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      final blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        topics: topics,
        updatedAt: DateTime.now(),
        imageUrl: '',
      );
      final imageUrl = await blogRemoteDatasource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      final updatedBlogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDatasource.uploadBlog(
        updatedBlogModel,
      );
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDatasource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
