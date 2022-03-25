import 'dart:convert';

class User {
  User(
      {required this.email,
      required this.lastname,
      required this.name,
      this.picture,
      this.id});

  String? email;
  String? lastname;
  String name;
  String? picture;
  String? id;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json["email"],
        lastname: json["last_name"],
        name: json["name"],
        picture: json["picture"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "last_name": lastname,
        "name": name,
        "picture": picture,
      };

  User copy() => User(
        email: this.email,
        lastname: this.lastname,
        name: this.name,
        picture: this.picture,
        id: this.id,
      );
}
