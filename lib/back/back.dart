import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Back {

  static Future<Map> getData(String url) async {
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  static Future<String> sendImageStorage(String path, File image) async {
    await firebase_core.Firebase.initializeApp();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
    await ref.putFile(image);
    String url = await ref.getDownloadURL();
    return url;
  }

  static Future<bool> deleteImageStorage(String path) async {
    await firebase_core.Firebase.initializeApp();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
    try {
      await ref.delete();
      return true;
    }on firebase_core.FirebaseException catch(e){
      return false;
    }
  }

}