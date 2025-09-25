import 'dart:io';

import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/core/network/connection_checker.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/datasources/blog_local_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/datasources/blog_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/models/blog_model.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;
  final BlogLocalDatasource blogLocalDatasource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDatasource,
    this.blogLocalDatasource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection!'));
      }
      BlogModel blogModel = BlogModel()
        ..id = const Uuid().v1()
        ..posterId = posterId
        ..title = title
        ..content = content
        ..topics = topics
        ..updatedAt = DateTime.now()
        ..imageUrl = '';

      final imageUrl = await blogRemoteDatasource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel.imageUrl = imageUrl;

      final uploadedBlogModel = await blogRemoteDatasource.uploadBlog(
        blogModel,
      );

      // Manually map the returned BlogModel to a Blog entity
      return right(
        Blog(
          id: uploadedBlogModel.id,
          posterId: uploadedBlogModel.posterId,
          title: uploadedBlogModel.title,
          content: uploadedBlogModel.content,
          topics: uploadedBlogModel.topics,
          updatedAt: uploadedBlogModel.updatedAt,
          imageUrl: uploadedBlogModel.imageUrl,
          posterName: uploadedBlogModel.posterName,
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final localBlogModels = blogLocalDatasource.loadBlogs();
        // Map the cached models to entities
        return right(_mapModelsToEntities(localBlogModels));
      }

      final remoteBlogModels = await blogRemoteDatasource.getAllBlogs();
      blogLocalDatasource.cacheBlogs(blogs: remoteBlogModels);

      // Map the remote models to entities
      return right(_mapModelsToEntities(remoteBlogModels));
    } on ServerException {
      // On server error, try to return from cache
      final localBlogModels = blogLocalDatasource.loadBlogs();
      return right(_mapModelsToEntities(localBlogModels));
    }
  }

  // Helper function to keep the code DRY
  List<Blog> _mapModelsToEntities(List<BlogModel> models) {
    return models
        .map(
          (model) => Blog(
            id: model.id,
            posterId: model.posterId,
            title: model.title,
            content: model.content,
            topics: model.topics,
            updatedAt: model.updatedAt,
            imageUrl: model.imageUrl,
            posterName: model.posterName,
          ),
        )
        .toList();
  }
}
