import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_app/mqtt/client.dart';
import 'package:mqtt_app/mqtt/message.dart';
import 'package:mqtt_client/mqtt_client.dart';


class _AppPageState extends State<App> {
  AndroidMqttClient client = new AndroidMqttClient('10.20.33.62', '');

  List<Message> messages = <Message>[];
  ScrollController messageScrollController = ScrollController();
  String time = "None";


  @override
  void initState() {
    startInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("AppBar"),
        ),
        body: ListView(
          controller: messageScrollController,
          children: _getMessages(),
        ),
      )
    );
  }

  void startInit() async{
    await client.makeConnect();
    print('APP::Subscribing to the /devices/tbot/controls/time topic');
    const String topic = '/devices/tbot/controls/time'; // Not a wildcard topic
    client.makeSubscribe(topic);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        time = pt;
        print(time);
        setState(() {
          messages.add(Message(
            message: pt, 
            topic: topic, 
            qos: recMess.payload.header.qos
            ));
        });
    });
  }

  List<Widget> _getMessages(){
    return messages
        .map((Message message) => Card(
              color: Colors.white70,
              child: ListTile(
                trailing: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'QoS',
                          style: TextStyle(fontSize: 8.0),
                        ),
                        Text(
                          message.qos.index.toString(),
                          style: TextStyle(fontSize: 8.0),
                        ),
                      ],
                    )),
                title: Text(message.topic),
                subtitle: Text(message.message),
                dense: true,
              ),
            ))
        .toList()
        .reversed
        .toList();
  }
}