import 'package:flutter/material.dart';
import 'package:mqtt_app/mqtt/topic.dart';
import 'package:mqtt_app/main.dart';

import 'package:mqtt_app/db/topic.dart' as model;
import 'package:mqtt_app/db/db.dart' as db;

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController topicSymbolsController = TextEditingController();
  final ScrollController listController = ScrollController();

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Topics")
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: listController,
              children: _buildTopicList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: new Text("Dialog title"),
                children: <Widget>[
                  SizedBox(
                    child: TextField(
                    controller:  topicNameController,
                    decoration: InputDecoration(hintText: 'Topic name'),
                    ),
                  ),
                  SizedBox(
                    child: TextField(
                    controller:  topicSymbolsController,
                    decoration: InputDecoration(hintText: 'Topic symbols'),
                    ),
                  ),
                  FlatButton(
                    child: new Text("Add"),
                    onPressed: (){
                      setState(() {
                        topics.add(
                        MqttTopic(name: topicNameController.text,
                              symbols: topicSymbolsController.text)
                       );
                      });
                      
                      var database = new db.DatabaseHelper();
                      var topic = new model.Topic(name: topicNameController.text, symbols: topicSymbolsController.text);
                      topic.setTopicId(1);
                      database.saveTopic(topic).then((r){print(r);});
                      database.getTopic().then((list){
                        for(var i in list){
                          print(i.name);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
          );
        },
      ),
    );
  }

  List<Widget> _buildTopicList(){
    return topics
        .map((MqttTopic topic) => Card(
              color: Colors.white70,
              child: ListTile(
                title: Text(topic.name),
                subtitle: Text(topic.symbols),
                dense: true,
              ),
            ))
        .toList()
        .reversed
        .toList();
  }
}