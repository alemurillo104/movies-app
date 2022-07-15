// To parse this JSON data, do
//
//     final cast = castFromJson(jsonString);

import 'dart:convert';

Cast castFromJson(String str) => Cast.fromJson(json.decode(str));

String castToJson(Cast data) => json.encode(data.toJson());

class Cast {
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  int castId;
  String character;
  String creditId;
  int order;

  get fullProfileImg => ( profilePath != null )
    ? 'https://image.tmdb.org/t/p/w500$profilePath'
    : 'https://i.stack.imgur.com/GNhxO.png';
  

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
      adult: json["adult"],
      gender: json["gender"],
      id: json["id"],
      knownForDepartment: json["known_for_department"],
      name: json["name"],
      originalName: json["original_name"],
      popularity: json["popularity"].toDouble(),
      profilePath: json["profile_path"],
      castId: json["cast_id"],
      character: json["character"],
      creditId: json["credit_id"],
      order: json["order"],
  );

  Map<String, dynamic> toJson() => {
      "adult": adult,
      "gender": gender,
      "id": id,
      "known_for_department": knownForDepartment,
      "name": name,
      "original_name": originalName,
      "popularity": popularity,
      "profile_path": profilePath,
      "cast_id": castId,
      "character": character,
      "credit_id": creditId,
      "order": order,
  };
}
