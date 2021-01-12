import 'package:flutter/material.dart';
import 'package:trimemoria/back/back.dart';
import 'package:trimemoria/pages/game.dart';

class ConfigGame extends StatefulWidget {
  @override
  _ConfigGameState createState() => _ConfigGameState();
}

class _ConfigGameState extends State<ConfigGame> {

  bool firstT = true;
  bool firstC = true;

  String theme,config;

  List _configs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure Game"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                  future: Back.getData('https://rest-api-trimemoria.herokuapp.com/theme'),
                  builder: (context, snapshot){
                    if(snapshot.hasData) {
                      if(firstT){
                        firstT = false;
                        theme = snapshot.data['data'][0]['name'];
                      }
                      return DropdownButton<String>(
                          value: theme,
                          elevation: 1,
                          items:
                          snapshot.data['data'].map<
                              DropdownMenuItem<String>>((v) {
                            return DropdownMenuItem<String>(
                                value: v['name'],
                                child: Text(v['name'])
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              theme = newValue;
                            });
                          }
                      );
                    }
                    else
                      return Container();
                  }
              ),
              FutureBuilder(
                  future: Back.getData('https://rest-api-trimemoria.herokuapp.com/configGame'),
                  builder: (context, snapshot){
                    if(snapshot.hasData) {
                      _configs =  snapshot.data['data'];
                      if(firstC){
                        firstC = false;
                        config = snapshot.data['data'][0]["name"];
                      }
                      return DropdownButton<String>(
                          value: config,
                          elevation: 1,
                          items:
                          snapshot.data['data'].map<
                              DropdownMenuItem<String>>((v) {
                            return DropdownMenuItem<String>(
                                value: v["name"],
                                child: Text(v['name'])
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              config = newValue;
                            });
                          }
                      );
                    }
                    else
                      return Container();
                  }
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white,fontSize: 25.0),
                    ),
                    onPressed: () async {
                      Map<String,dynamic> theme = await Back.getData("https://rest-api-trimemoria.herokuapp.com/theme/image/${this.theme}");
                      Map<String,dynamic> configuration = _configs.firstWhere((element) => element["name"] == this.config);
                      if(theme.keys.contains("data")){
                        if(configuration["configurationTag"].length == theme["data"].length){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Game(theme: this.theme, config: configuration))
                          );
                        }else{
                          print("A quantidade de imagens do tema não é igual a quantidade da matriz");
                        }
                      }
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
