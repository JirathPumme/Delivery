// To parse this JSON data, do
//
//     final userDataList = userDataListFromJson(jsonString);

import 'dart:convert';

// UserDataList userDataListFromJson(String str) => UserDataList.fromJson(json.decode(str));

// String userDataListToJson(UserDataList data) => json.encode(data.toJson());
List<UserDataList> userDataListFromJson(String str) =>
    List<UserDataList>.from(
      json.decode(str).map((x) => UserDataList.fromJson(x)),
    );

String userDataListToJson(List<UserDataList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDataList {
  String? id; // Make id optional
  int roleId;
  String phoneNumber;
  String password;

  UserDataList({
    this.id, // optional
    required this.roleId,
    required this.phoneNumber,
    required this.password,
  });

  // ✅ Use named optional parameter for docId
  factory UserDataList.fromJson(Map<String, dynamic> json, {String? docId}) {
    return UserDataList(
      id: docId ?? json["id"], // use Firestore doc.id if provided, otherwise from JSON
      roleId: json["role_id"],
      phoneNumber: json["phone_number"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "phone_number": phoneNumber,
        "password": password,
      };
}
