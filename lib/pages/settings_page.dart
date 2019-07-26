import 'package:flutter/material.dart';
import 'page.dart';

class SettingsPage implements Page{
  List<Widget> settings = <Widget>[];

  TextEditingController brokerController = TextEditingController();
  TextEditingController brokerPortController = TextEditingController();

  Scaffold buildPage() {
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
      ],
    )); 
    return settings.toList();
  } 
}