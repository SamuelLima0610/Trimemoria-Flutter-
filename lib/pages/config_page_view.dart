import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/tabs/OrganizationTagGame.dart';
import 'package:trimemoria/tabs/TcpDevice.dart';
import 'package:trimemoria/tabs/ThemeGame.dart';
import 'package:trimemoria/models/DataModel.dart';
import 'package:trimemoria/tabs/ThemesImages.dart';

// ignore: must_be_immutable
class ConfigPageView extends StatelessWidget {

  PageController pageController;

  @override
  Widget build(BuildContext context) {
    Color orange = Color(0xFFFF8306);
    return PageView(
      controller: pageController,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Theme",style: TextStyle(color: Colors.white),),
            centerTitle: true,
            backgroundColor: orange,
          ),
          body: ScopedModel(
              model: DataModel('https://rest-api-trimemoria.herokuapp.com/config/themes'),
              child: ThemeGame()
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configuration of dispositive",
                style: TextStyle(color: Colors.white)
            ),
            backgroundColor: orange,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: TcpDevice(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configuration of Matrix Game",
                style: TextStyle(color: Colors.white)
            ),
            backgroundColor: orange,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: ScopedModel(
              model: DataModel('https://rest-api-trimemoria.herokuapp.com/config/configuration'),
              child: OrganizationTagGame()
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
                "Configuration of Theme's Image",
                style: TextStyle(color: Colors.white)
            ),
            backgroundColor: orange,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: ScopedModel(
              model: DataModel('https://rest-api-trimemoria.herokuapp.com/config/imageTheme'),
              child: ThemesImages()
          ),
        )
      ],
    );
  }
}
