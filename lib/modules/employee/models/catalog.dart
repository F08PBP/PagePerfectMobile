// To parse this JSON data, do
//
//     final catalog = catalogFromJson(jsonString);

import 'dart:convert';

List<Catalog> catalogFromJson(String str) => List<Catalog>.from(json.decode(str).map((x) => Catalog.fromJson(x)));

String catalogToJson(List<Catalog> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Catalog {
    String model;
    int pk;
    Fields fields;

    Catalog({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
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
    int book;
    bool isShowToMember;

    Fields({
        required this.book,
        required this.isShowToMember,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        isShowToMember: json["isShowToMember"],
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "isShowToMember": isShowToMember,
    };
}
