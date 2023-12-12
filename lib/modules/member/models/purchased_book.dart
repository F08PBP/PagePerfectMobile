// To parse this JSON data, do
//
//     final purchased = purchasedFromJson(jsonString);

import 'dart:convert';

List<Purchased> purchasedFromJson(String str) => List<Purchased>.from(json.decode(str).map((x) => Purchased.fromJson(x)));

String purchasedToJson(List<Purchased> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Purchased {
    String model;
    int pk;
    Fields fields;

    Purchased({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Purchased.fromJson(Map<String, dynamic> json) => Purchased(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int boughtItem;
    int member;
    int book;
    int quantity;

    Fields({
        required this.boughtItem,
        required this.member,
        required this.book,
        required this.quantity,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        boughtItem: json["bought_item"],
        member: json["member"],
        book: json["book"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "bought_item": boughtItem,
        "member": member,
        "book": book,
        "quantity": quantity,
    };
}
