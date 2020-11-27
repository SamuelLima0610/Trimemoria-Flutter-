import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/tabs/OrganizationTagGame.dart';
import 'package:trimemoria/tabs/TcpDevice.dart';
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
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configuration of dispositive"),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: TcpDevice(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configuration of Matrix Game"),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: ScopedModel(
              model: DataModel('https://rest-api-trimemoria.herokuapp.com/configGame'),
              child: OrganizationTagGame()
          ),
        )
      ],
    );
  }
}
