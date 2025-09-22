import 'package:flutter/material.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:bloc_app_clean_solidp_bloc/core/theme/app_pallete.dart';

class AddNewBlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (ctx) => AddNewBlogScreen());
  const AddNewBlogScreen({super.key});

  @override
  State<AddNewBlogScreen> createState() => _AddNewBlogScreenState();
}

class _AddNewBlogScreenState extends State<AddNewBlogScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: DottedDecoration(
                  color: AppPallete.borderColor,
                  strokeWidth: 2,
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 50),
                    SizedBox(height: 20),
                    Text('Select your Image', style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['Technology', 'Business', 'Programing', 'Entertainment']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                  } else {
                                    selectedTopics.add(e);
                                  }
                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedTopics.contains(e)
                                      ? const WidgetStatePropertyAll(
                                          AppPallete.gradient1,
                                        )
                                      : null,
                                  side: BorderSide(color: AppPallete.gradient2),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 30),
              BlogEditor(hintText: 'Blog title', controller: titleController),
              SizedBox(height: 20),
              BlogEditor(
                hintText: 'Blog Content',
                controller: contentController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
