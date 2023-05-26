// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
    String id;
    String userId;
    String postId;
    String username;
    final date;
    String avatar;
    String comment;
    List<String> likes;

    Comment({
        required this.id,
        required this.userId,
        required this.postId,
        required this.username,
        required this.date,
        required this.avatar,
        required this.comment,
        required this.likes,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["userId"],
        postId: json["postId"],
        username: json["username"],
        date: json["date"],
        avatar: json["avatar"],
        comment: json["comment"],
        likes: List<String>.from(json["likes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "username": username,
        "date": date,
        "avatar": avatar,
        "comment": comment,
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}
