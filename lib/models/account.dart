import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    String id;
    String avatar;
    String email;
    List<dynamic> followers;
    List<dynamic> following;
    String username;

    Account({
        required this.id,
        required this.avatar,
        required this.email,
        required this.followers,
        required this.following,
        required this.username,
    });

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        avatar: json["avatar"],
        email: json["email"],
        followers: List<dynamic>.from(json["followers"].map((x) => x)),
        following: List<dynamic>.from(json["following"].map((x) => x)),
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "email": email,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
        "username": username,
    };
}
