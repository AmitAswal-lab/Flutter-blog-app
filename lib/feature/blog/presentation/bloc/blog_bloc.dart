import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
  }
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await uploadBlog(
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
      (onRight) => emit(BlogSuccess()),
    );
  }
}
