import 'dart:async';
import 'package:flutter/material.dart';

// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<Map<String,dynamic>>();

  void Function(Map<String,dynamic>) get addResponse => _socketResponse.sink.add;

  Stream<Map<String,dynamic>> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket =StreamSocket();

//Step3: Build widgets with streambuilder

class BuildWithSocketStream extends StatelessWidget {
  const BuildWithSocketStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: streamSocket.getResponse ,
        builder: (context,snapshot){
          if(snapshot.hasData)
            return Container(
              child: Text(snapshot.data["tag"]),
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}