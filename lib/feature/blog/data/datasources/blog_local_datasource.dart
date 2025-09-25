import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/models/blog_model.dart';
import 'package:isar/isar.dart';

abstract interface class BlogLocalDatasource {
  void cacheBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDatasourceImpl implements BlogLocalDatasource {
  final Isar isar;
  BlogLocalDatasourceImpl(this.isar);
  @override
  List<BlogModel> loadBlogs() {
    // Use a read transaction to get all blogs from the collection
    return isar.blogModels.where().findAllSync();
  }

  @override
  void cacheBlogs({required List<BlogModel> blogs}) {
    // Use a read transaction to get all blogs from the collection
    isar.writeTxnSync(() {
      isar.blogModels.clearSync();
      isar.blogModels.putAllSync(blogs);
    });
  }
}
