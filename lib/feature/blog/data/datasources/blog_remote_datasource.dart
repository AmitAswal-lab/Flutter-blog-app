import 'dart:io';

import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract interface class BlogRemoteDatasource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
}

class BlogRemoteDatasourceImpl extends BlogRemoteDatasource {
  final SupabaseClient supabaseClient;
  BlogRemoteDatasourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async{
    try {
      final blogData = await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } on ServerException catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String> uploadBlogImage({required File image, required BlogModel blog})async {

    try{
     await supabaseClient.storage.from('blog_images').upload(blog.id, image);
     return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on ServerException catch(e){
      throw ServerException(e.toString());
    }
  }
}
