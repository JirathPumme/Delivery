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
  String username;
  int roleId;
  String phoneNumber;
  String password;
  String? address;
  String? gps;

  UserDataList({
    this.id, // optional
    required this.username,
    required this.roleId,
    required this.phoneNumber,
    required this.password,
    this.address,
    this.gps,
  });

  // ✅ Use named optional parameter for docId
  factory UserDataList.fromJson(Map<String, dynamic> json, {String? docId}) {
    return UserDataList(
      id: docId ?? json["id"], // use Firestore doc.id if provided, otherwise from JSON
      username: json["username"],
      roleId: json["role_id"],
      phoneNumber: json["phone_number"],
      password: json["password"],
      address: json["address"] ?? "",
      gps: json["gps"] ?? ""
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "role_id": roleId,
        "phone_number": phoneNumber,
        "password": password,
        "address": address,
        "gps": gps
      };
}
