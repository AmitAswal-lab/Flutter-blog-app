import 'package:bloc_app_clean_solidp_bloc/core/common/widgets/loader.dart';
import 'package:bloc_app_clean_solidp_bloc/core/utils/show_snackbar.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/screens/add_new_blog_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (ctx) => BlogScreen());
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(AddNewBlogScreen.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (ctx, index) {
                final blog = state.blogs[index];
                return Text(blog.title);
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
