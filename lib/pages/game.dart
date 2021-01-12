import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/back/back.dart';
import 'package:trimemoria/models/gameModel.dart';

class Game extends StatefulWidget {

  final String theme;
  Map<String,dynamic> config;
  Game({this.theme,this.config});

  @override
  _GameState createState() => _GameState(this.theme,this.config);
}

class _GameState extends State<Game> {

  String theme;
  Map<String,dynamic> config;
  int cardsFlip = 0;

  _GameState(this.theme,this.config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: Back.getData('https://rest-api-trimemoria.herokuapp.com/theme/image/${theme}'),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List cards = snapshot.data['data'].map((v){
                    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
                    v["isFlip"] = false;
                    v["keyFlip"] = cardKey;
                    return v;
                  }).toList();
                  String coordMatrix = getLastCoordinate(config["configurationTag"]);
                  int row = int.parse(coordMatrix.substring(0,1));
                  //int column = int.parse(coordMatrix.substring(1));
                  return ScopedModel<GameModel>(
                      model: GameModel(cards),
                      child: ScopedModelDescendant<GameModel>(
                          builder: (context, child, model){
                            return GridView.count(
                              crossAxisCount: row,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              children: model.cards.map((card){
                                return FlipCard(
                                  key: card["keyFlip"],
                                  flipOnTouch: false,
                                  onFlip: (){
                                    model.onFlip(card);
                                  },
                                  front: InkWell(
                                    onTap: (){
                                      model.onTap(card);
                                    },
                                    child: Container(
                                      child: Image.network(
                                        "https://picsum.photos/500/300?image=0",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  back: Container(
                                    child: Image.network(
                                      card["href"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                      )
                  );
                }else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
          )
      ),
    );
  }

  String getLastCoordinate(List<dynamic> configTags){
    return configTags.last.keys.first.toString();
  }
}
