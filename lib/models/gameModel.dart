import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/pages/game.dart';


class GameModel extends Model{

  List cards;
  int cardsFlip = 0;
  List<Map<String,dynamic>> selectedCards = [];
  StreamSocket streamSocket;

  GameModel({this.cards});

  void onFlip(Map<String,dynamic> card){
    card["isFlip"] = !card["isFlip"];
    notifyListeners();
  }

  void onTap(Map<String,dynamic> card){
    if(card["isFlip"] == false && cardsFlip <= 2) {
      selectedCards.add(card);
      cardsFlip++;
      GlobalKey<FlipCardState> cardKey = card["keyFlip"];
      cardKey.currentState.toggleCard();
      if(cardsFlip == 3){
        Future.delayed(Duration(seconds: 2)).then((value){
          List equals = selectedCards.where((element) =>
                                               element["group"]
                                                .toString()
                                                .compareTo(selectedCards[0]["group"]
                                                .toString()) == 0).toList();
          if(equals.length != 3){
            selectedCards.forEach((card){
              GlobalKey<FlipCardState> cardKey = card["keyFlip"];
              cardKey.currentState.toggleCard();
              card["isFlip"] = false;
              notifyListeners();
            });
          }
          clear();
        });
      }
    }
  }

  void clear(){
    cardsFlip = 0;
    selectedCards = [];
    notifyListeners();
  }
}