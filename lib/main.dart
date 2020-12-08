import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/tabs/ThemesImages.dart';

import 'models/DataModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Configuration of Matrix Game"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ScopedModel<DataModel>(
            model: DataModel('https://rest-api-trimemoria.herokuapp.com/image'),
            child: ThemesImages()
        ),
      ),
    );
  }
}



