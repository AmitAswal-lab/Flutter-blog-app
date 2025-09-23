import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.topics,
    required super.updatedAT,
    required super.imageUrl,
  });

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    List<String>? topics,
    String? imageUrl,
    DateTime? updatedAT,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAT: updatedAT ?? this.updatedAT,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'topics': topics,
      'image_url': imageUrl,
      'updated_at': updatedAT.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics']),
      updatedAT: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }
}
