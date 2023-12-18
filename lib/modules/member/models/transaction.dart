// To parse this JSON data, do
//
//     final transaksi = transaksiFromJson(jsonString);

import 'dart:convert';

List<Transaksi> transaksiFromJson(String str) => List<Transaksi>.from(json.decode(str).map((x) => Transaksi.fromJson(x)));

String transaksiToJson(List<Transaksi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaksi {
    String model;
    int pk;
    Fields fields;

    Transaksi({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
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
    int member;
    DateTime dateAdded;
    String notes;
    List<dynamic> cart;

    Fields({
        required this.member,
        required this.dateAdded,
        required this.notes,
        required this.cart,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        member: json["member"],
        dateAdded: DateTime.parse(json["date_added"]),
        notes: json["notes"],
        cart: List<dynamic>.from(json["cart"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "member": member,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "notes": notes,
        "cart": List<dynamic>.from(cart.map((x) => x)),
    };
}
