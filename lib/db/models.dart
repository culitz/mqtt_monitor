class Settings {
  int id;
  String brokerHost;
  String brokerPort;

  Settings({this.brokerHost, this.brokerPort});

  Settings.map(dynamic obj) {
    this.brokerHost = obj["brokerHost"];
    this.brokerPort = obj["brokerPort"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["brokerHost"] = brokerHost;
    map["brokerPort"] = brokerPort;
    return map;
  }

  void setSettingsId(int id) {
    this.id = id;
  }
}

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
    return map;
  }

  void setTopicId(int id) {
    this.id = id;
  }
}