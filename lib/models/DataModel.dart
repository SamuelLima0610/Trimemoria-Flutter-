import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataModel extends Model {

  List _list = [];
  bool edit = false; // 0 - save 1 - edit
  String _url;
  Map<String,dynamic> information = null;
  String key = "pyzdQxKCneRl";

  DataModel(this._url);

  Future<List> getList() async{
    Map data = await _getData();
    _list = data['data'];
    return _list;
  }

  Future<String> insert({@required Map<String, dynamic> data, int id}) async{
    http.Response resp;
    if(!edit){
      resp = await _send(
          data
      );
    }else{
      resp = await _send(
          data
      );
    }
    Map map = json.decode(resp.body);
    refresh();
    return map['data'];
  }

  Future<String> destroy() async{
    http.Response resp;
    resp = await _destroy();
    if(resp.statusCode == 200){
      refresh();
    }
    Map map = json.decode(resp.body);
    return map['data'];
  }

  Future<Map> _getData() async {
    http.Response response = await http.get(
        Uri.parse(_url),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $key',
        },
    );
    return json.decode(response.body);
  }

  Future<http.Response> _send(Map<String, dynamic> data) {
    if(!edit){
      return http.post(
        _url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $key',
        },
        body: json.encode(data),
      );
    }
    else{
      if(information != null){
        data['id'] = information['data']['id'];
        return http.put(
          information['_links'][1]['href'],
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $key',
          },
          body: json.encode(data),
        );
      }
      return null;
    }
  }

  Future<Map> _getDataById(int id) async {
    http.Response response = await http.get(
        '${_url}/${id}',
        headers: {
          'Authorization': 'Bearer $key'
        }
    );
    return json.decode(response.body);
  }

  Future<http.Response> _destroy(){
    return http.delete(
        information['_links'][0]['href'],
        headers: {
          'Authorization': 'Bearer $key'
        }
    );
  }

  void change({int id}) async{
    edit = true;
    information = await _getDataById(id);
    print(information);
    notifyListeners();
  }

  bool toEdit(){
    return edit;
  }

  void refresh() async {
    edit = false;
    information = null;
    _list = await getList();
    notifyListeners();
  }

}