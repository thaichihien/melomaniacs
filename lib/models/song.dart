// To parse this JSON data, do
//
//     final song = songFromJson(jsonString);

import 'dart:convert';

List<Song> songFromJson(String str) => List<Song>.from(json.decode(str).map((x) => Song.fromJson(x)));

String songToJson(List<Song> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Song {
    String title;
    List<String> artist;
    String image;
    String link;

    Song({
        required this.title,
        required this.artist,
        required this.image,
        required this.link,
    });

    factory Song.fromJson(Map<String, dynamic> json) => Song(
        title: json["title"],
        artist: List<String>.from(json["artist"].map((x) => x)),
        image: json["image"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "artist": List<dynamic>.from(artist.map((x) => x)),
        "image": image,
        "link": link,
    };
}
