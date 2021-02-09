import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class TagSocket extends Model{

  SocketIO socketIO;
  List<Map<String, dynamic>> list = [];

  void init(){
    print("Inicia");
    socketIO = SocketIOManager().createSocketIO(
        'https://rest-api-trimemoria.herokuapp.com', '',
    );
    socketIO.init();

    socketIO.subscribe('tag', _listenTag);

    socketIO.connect();

  }

  void dispose(){
    socketIO.disconnect();
  }

  void _listenTag(dynamic json){
    Map<String, dynamic> data = json.decode(json);
    list.add(data);
    print("Foi" + json);
    notifyListeners();
  }
}