import 'dart:convert';

class Topic {
  int id;
  String name;
  String symbols;

  Topic({this.name, this.symbols});

  Topic.map(dynamic obj) {
    this.name = obj["name"];
    this.symbols = obj["symbols"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["symbols"] = symbols;
    print(map);
    return map;
  }

  void setTopicId(int id) {
    this.id = id;
    print(id);
  }
}