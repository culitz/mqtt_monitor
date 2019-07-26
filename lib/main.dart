import 'package:flutter/material.dart';
import 'package:mqtt_app/mqtt/message.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt/client.dart';
import 'pages/message_page.dart' as msgPage;
import 'pages/settings_page.dart' as stgPage;
import 'pages/topic_page.dart' as topPage;

void main() async {
  runApp(App());
}


class App extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<App> {
  // Pages
  msgPage.MessagePage messagePage = new msgPage.MessagePage();
  stgPage.SettingsPage settingsPage = new stgPage.SettingsPage();
  topPage.TopicPage topicPage = new topPage.TopicPage();

  AndroidMqttClient client = new AndroidMqttClient('10.20.33.62', '');
  String time = "None";

  PageController _pageController;
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    startInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
      //  appBar: AppBar(
      //    title: Text("mqtt"),
      //  ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          settingsPage.buildPage(),
          messagePage.buildPage(),
          topicPage.buildPage(),
        ],
      ), 
      ),
    );
  }


  void startInit() async{
    await client.makeConnect();
    print('APP::Subscribing to the /devices/hwmon/controls/CPU Temperature');
    const String topic = '/devices/hwmon/controls/CPU Temperature';
    client.makeSubscribe(topic);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        time = pt;
        print(time);
        setState(() {
          messagePage.messages.add(Message(
            message: pt, 
            topic: topic, 
            qos: recMess.payload.header.qos
            ));
        });
    });
  }
}
