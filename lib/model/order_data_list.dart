// To parse this JSON data, do
//
//     final orderdatalist = orderdatalistFromJson(jsonString);

import 'dart:convert';


// List<Orderdatalist> userDataListFromJson(String str) =>
//     List<Orderdatalist>.from(
//       json.decode(str).map((x) => Orderdatalist.fromJson(x)),
//     );

// String userDataListToJson(List<Orderdatalist> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Orderdatalist orderdatalistFromJson(String str) => Orderdatalist.fromJson(json.decode(str));

String orderdatalistToJson(Orderdatalist data) => json.encode(data.toJson());

class Orderdatalist {
    String id;
    String product;
    String pickup;
    String dropoff;

    Orderdatalist({
        required this.id,
        required this.product,
        required this.pickup,
        required this.dropoff,
    });

    factory Orderdatalist.fromJson(Map<String, dynamic> json) => Orderdatalist(
        id: json["id"],
        product: json["product"],
        pickup: json["pickup"],
        dropoff: json["dropoff"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "pickup": pickup,
        "dropoff": dropoff,
    };
}
