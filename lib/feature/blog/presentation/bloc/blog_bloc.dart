import 'dart:io';
import 'package:bloc_app_clean_solidp_bloc/core/usecase/usecase.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _uploadBlog = uploadBlog,
      _getAllBlogs = getAllBlogs,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onGetAllBlogs);
  }
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(
      UploadBlogParams(
        title: event.title,
        content: event.content,
        posterId: event.posterId,
        image: event.image,
        topics: event.topics,
      ),
    );
    result.fold(
      (onLeft) => emit(BlogFailure(onLeft.message)),
      (onRight) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final response = await _getAllBlogs(NoParams());
    response.fold(
      (onLeft) => emit(BlogFailure(onLeft.message)),
      (onRight) => emit(BlogDisplaySuccess(blogs: onRight)),
    );
  }
}
