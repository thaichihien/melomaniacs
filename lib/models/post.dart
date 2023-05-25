// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    String id;
    String userId;
    String caption;
    String username;
    final date;
    String avatar;
    List<String> images;
    List<String> likes;

    Post({
        required this.id,
        required this.userId,
        required this.caption,
        required this.username,
        required this.date,
        required this.avatar,
        required this.images,
        required this.likes,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["userId"],
        caption: json["caption"],
        username: json["username"],
        date: json["date"],
        avatar: json["avatar"],
        images: List<String>.from(json["images"].map((x) => x)),
        likes: List<String>.from(json["likes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "caption": caption,
        "username": username,
        "date": date,
        "avatar": avatar,
        "images": List<dynamic>.from(images.map((x) => x)),
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}
