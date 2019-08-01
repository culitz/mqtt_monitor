import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  List<Widget> settings = <Widget>[];

  TextEditingController brokerController = TextEditingController();
  TextEditingController brokerPortController = TextEditingController();

  @override
  Widget build (BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildWidgets(),
      )
    );
  }

  List<Widget> _buildWidgets(){
    settings.clear();
    settings.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: TextField(
            controller:  brokerController,
            decoration: InputDecoration(hintText: 'Broker address'),
          ),
        ),
        SizedBox(
          child: TextField(
            controller: brokerPortController,
            decoration: InputDecoration(hintText: 'Broker port'),
          ),
        ),
        FlatButton(
          child: Icon(Icons.autorenew),
          onPressed: () {

          },
        )
      ],
    )); 
    return settings.toList();
  } 
}