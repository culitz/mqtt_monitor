import 'package:flutter/material.dart';

import 'page.dart';

class TopicPage implements Page {
  List<Widget> widgets = <Widget>[];

  List<Widget> _buildWidgets(){
    widgets.clear();
    widgets.add(
      Column(
        children: <Widget>[
          RaisedButton(
          child: Text("Add"),
          onPressed: () {
            print("OnPress");
          },
        ),
        ]
      )
    );
    return widgets.toList();
  } 

  Scaffold buildPage(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Topics")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Wow");
        },
      ),
    );
  }
}