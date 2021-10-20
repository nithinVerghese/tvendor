import 'dart:convert';

List<NameListModel> nameListModelFromJson(String str) => List<NameListModel>.from(json.decode(str).map((x) => NameListModel.fromJson(x)));

String nameListModelToJson(List<NameListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NameListModel {
  NameListModel({
    this.name,
    this.docNumber,
  });

  String name;
  String docNumber;

  factory NameListModel.fromJson(Map<String, dynamic> json) => NameListModel(
    name: json["name"],
    docNumber: json["doc_number"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "doc_number": docNumber,
  };
}
