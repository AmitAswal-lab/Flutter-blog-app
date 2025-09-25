import 'package:isar/isar.dart';

part 'blog_model.g.dart'; // For the code generator

@collection
class BlogModel {
  // THE CHANGE: Use the standard Isar auto-incrementing ID type.
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id; // Your original UUID from Supabase

  late String posterId;
  late String title;
  late String content;
  late List<String> topics;
  late DateTime updatedAt;
  late String imageUrl;
  String? posterName;

  // No-argument constructor
  BlogModel();

  // Your fromJson and toJson methods remain unchanged, but are here for completeness.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'topics': topics,
      'image_url': imageUrl,
      'updated_at': updatedAt.toIso8601String(),
      'poster_name': posterName,
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel()
      ..id = map['id'] as String
      ..posterId = map['poster_id'] as String
      ..title = map['title'] as String
      ..content = map['content'] as String
      ..imageUrl = map['image_url'] as String
      ..topics = List<String>.from(map['topics'])
      ..updatedAt = map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'])
      ..posterName = map['poster_name'] as String?;
  }
}
