import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mqtt/client.dart';
import 'package:mqtt_client/mqtt_client.dart';

AndroidMqttClient client = new AndroidMqttClient('10.20.33.62', '');
String time = "time";
ValueNotifier<String> mTime = new ValueNotifier("time");
MqttEvent mHome = MqttEvent();
void main() async {
  runApp(App());
  startInit();
}

void startInit() async{
  await client.makeConnect();
  print('APP::Subscribing to the /devices/tbot/controls/time topic');
  const String topic = '/devices/tbot/controls/time'; // Not a wildcard topic
  await client.makeSubscribe(topic);
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // print(
      //     'APP::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      time = pt;
      print(time);
  });


  print('EXAMPLE::Sleeping....');
  await MqttUtilities.asyncSleep(120);
  print('EXAMPLE::Disconnecting');
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Mqtt monitor",
      home:mHome
    );
  }
}

class MqttEvent extends StatefulWidget {
  @override
  MqttEventState createState() {
    return new MqttEventState();
  }
}

class MqttEventState extends State<MqttEvent> {
  String _time = "nop";
  Text time = new Text("nop");
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Mqtt monitor",)),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: time,
            ),
            on
          ],
        ),
      ),
    );
  }
}