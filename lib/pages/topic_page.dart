import 'package:flutter/material.dart';
import 'package:mqtt_app/db/models.dart' as models;
import 'package:mqtt_app/mqtt/message.dart';
import 'package:mqtt_app/mqtt/client.dart';

import 'package:mqtt_app/db/topic_service.dart';
import 'package:mqtt_app/db/settings_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_app/main.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController topicSymbolsController = TextEditingController();
  final ScrollController listController = ScrollController();
  
  AndroidMqttClient client;

  final TopicService topicService = TopicService();
  final SettingsService settingsServise = SettingsService();

  List<models.Topic> dbTopics = <models.Topic>[];

  List<Widget> settings = <Widget>[];


  TextEditingController brokerController = TextEditingController();
  TextEditingController brokerPortController = TextEditingController();

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Topics"),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.code),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: new Text("Dialog title"),
                    children: _buildWidgets(),
                  );
                }
              );
            },
          )
        ],
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
                      var topic = new models.Topic(name: topicNameController.text, symbols: topicSymbolsController.text);
                      topicService.saveTopic(topic).then((value){
                        setState(() {});
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

  List<Widget> _buildTopicList() {   
    topicService.getTopic().then(
      (List<models.Topic> topicList){
        dbTopics.clear();
        topicList.forEach((topic){
          dbTopics.add(topic);
        });
        setState(() {});
      }
    );
    return dbTopics
        .map((models.Topic topic) => Card(
              color: Colors.white70,
              child: ListTile(
                title: Text(topic.name),
                subtitle: Text(topic.symbols),
                dense: true,
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: new Text("Dialog title"),
                        children: <Widget>[
                          FlatButton(
                            child: new Text("Delete"),
                            onPressed: (){
                              topicService.deleteTopic(topic).then((value){
                                setState(() {
                                  print('deleted. $value');
                                });
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                    );
                  });
                },
              ),
            ))
        .toList()
        .reversed
        .toList();
  }

  List<Widget> _buildWidgets(){
    settings.clear();
    String brokerHost = 'Broker address';
    String brokerPort = 'Broker port';

    settingsServise.getSettings().then((settingsList){
      setState(() {
        brokerHost = settingsList.first.brokerHost;
        brokerPort = settingsList.first.brokerPort;
      });
    });

    settings.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: TextField(
            controller:  brokerController,
            decoration: InputDecoration(hintText: brokerHost),
          ),

        ),
        SizedBox(
          child: TextField(
            controller: brokerPortController,
            decoration: InputDecoration(hintText: brokerPort),
          ),
        ),
        FlatButton(
          child: Icon(Icons.autorenew),
          onPressed: () {
            settingsServise.getSettings().then((settingsList)  {
                print('settings $settingsList');
                if(settingsList.first == null || settingsList.length == 0){
                  settingsServise.saveSettings(models.Settings(brokerHost: '', brokerPort: '')).then((value){
                    connect().then((value){
                      print(value);
                    }).catchError((error){
                      print('Errors: $error');
                    });
                  });
                }else{
                  settingsList.first.brokerHost = brokerController.text;
                  settingsList.first.brokerPort = brokerPortController.text;
                  settingsServise.update(settingsList.first);
                  print(settingsList.first);
                }
            });
          },
        )
      ],
    )); 
    return settings.toList();
  }


  Future<bool> connect() async{
    settingsServise.getSettings().then((List<models.Settings> settings){
      client = AndroidMqttClient(
        settings.first.brokerHost,
        settings.first.brokerPort
      );
      client.connect().then((status){
        topicService.getTopic().then((List<models.Topic> topics){
          topics.forEach((topic){
            client.subscribe(topic.symbols,  MqttQos.atMostOnce);
            client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
              final MqttPublishMessage recMess = c[0].payload;
              final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

              setState(() {
                messages.add(Message(
                  message: pt, 
                  topic: topic.name, 
                  qos: recMess.payload.header.qos
                  ));
              });
            });
          });
        });
      }).catchError((error){
        print(error);
      });
    });

    // client.connect();
    // await client.makeConnect();
    // print('APP::Subscribing to the /devices/hwmon/controls/CPU Temperature');
    // const String topic = '/devices/hwmon/controls/CPU Temperature';
    // client.makeSubscribe(topic);

    // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //     final MqttPublishMessage recMess = c[0].payload;
    //     final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    //     setState(() {
    //       messages.add(Message(
    //         message: pt, 
    //         topic: topic, 
    //         qos: recMess.payload.header.qos
    //         ));
    //     });
    // });
    return true;
  }
}