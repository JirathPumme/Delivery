// To parse this JSON data, do
//
//     final ondeliveryList = ondeliveryListFromJson(jsonString);

import 'dart:convert';


List<OndeliveryList> userDataListFromJson(String str) =>
    List<OndeliveryList>.from(
      json.decode(str).map((x) => OndeliveryList.fromJson(x)),
    );

String userDataListToJson(List<OndeliveryList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


// OndeliveryList ondeliveryListFromJson(String str) => OndeliveryList.fromJson(json.decode(str));

// String ondeliveryListToJson(OndeliveryList data) => json.encode(data.toJson());

class OndeliveryList {
    String title;
    String phoneReciver;
    String pickup;
    String dropoff;
    String status;

    OndeliveryList({
        required this.title,
        required this.phoneReciver,
        required this.pickup,
        required this.dropoff,
        required this.status,
    });

    factory OndeliveryList.fromJson(Map<String, dynamic> json) => OndeliveryList(
        title: json["title"],
        phoneReciver: json["phone_reciver"],
        pickup: json["pickup"],
        dropoff: json["dropoff"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "phone_reciver": phoneReciver,
        "pickup": pickup,
        "dropoff": dropoff,
        "status": status,
    };
}
