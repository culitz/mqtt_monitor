import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';


class AndroidMqttClient extends MqttClient{

  AndroidMqttClient(String server, String clientIdentifier) : super(server, clientIdentifier){
    super.logging(on: false);
    super.keepAlivePeriod = 20;
    super.onConnected = this.connected;
    super.onDisconnected = this.disconnected;
    super.onSubscribed = this.subscribed;

    /// Create a connection message to use or use the default one. The default one sets the
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    super.connectionMessage = connMess;
  }

  void makeConnect() async{
    try {
      await super.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      super.disconnect();
    }

    /// Check we are connected
    if (super.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${super.connectionStatus}');
      super.disconnect();
    }
  }

  void makeSubscribe(String topic) async{
    super.subscribe(topic, MqttQos.atMostOnce);
  }

  void subscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void disconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (this.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  void connected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }


}