import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/tabs/ThemeGame.dart';
import 'package:trimemoria/models/DataModel.dart';

// ignore: must_be_immutable
class ConfigPageView extends StatelessWidget {

  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Theme"),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: ScopedModel(
              model: DataModel('https://rest-api-trimemoria.herokuapp.com/theme'),
              child: ThemeGame()
          ),
        )
      ],
    );
  }
}
