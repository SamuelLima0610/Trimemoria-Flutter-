import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/back/back.dart';
import 'package:trimemoria/models/gameModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<int>();

  void Function(int) get addResponse => _socketResponse.sink.add;

  Stream<int> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

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
  IO.Socket socket;
  List cards;

  _GameState(this.theme,this.config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: displayGame()
      ),
    );
  }

  Widget displayCard(Map<String,dynamic> card, GameModel model){
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
  }

  Widget displayGame(){
    return FutureBuilder(
        future: Back.getData('https://rest-api-trimemoria.herokuapp.com/theme/image/${theme}'),
        builder: (context,snapshot){
          if(snapshot.hasData){
            cards = snapshot.data['data'].map((v){
              GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
              v["isFlip"] = false;
              v["keyFlip"] = cardKey;
              return v;
            }).toList();
            String coordMatrix = getLastCoordinate(config["configurationTag"]);
            int row = int.parse(coordMatrix.substring(0,1));
            //int column = int.parse(coordMatrix.substring(1));
            return ScopedModel<GameModel>(
                model: GameModel(cards: cards,),
                child: ScopedModelDescendant<GameModel>(
                    builder: (context, child, model){
                      return StreamBuilder(
                        stream: streamSocket.getResponse ,
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            Map<String,dynamic> card = model.cards.elementAt(snapshot.data);
                            model.onTap(card);
                          }
                          return GridView.count(
                            crossAxisCount: row,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            children: model.cards.map((card){
                              return displayCard(card, model);
                            }).toList(),
                          );
                        },
                      );
                    }
                )
            );
          }else
            return Center(
              child: CircularProgressIndicator(),
            );
        }
    );
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen(){
    socket = IO.io('https://rest-api-trimemoria.herokuapp.com',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('tag', (data) {
      List<dynamic> display = config["configurationTag"];
      int index = 0;
      display.forEach((element) {
        Map<String,dynamic> map = element;
        if(map.values.first.toString() == data["tag"]){
          streamSocket.addResponse(index);
        }
        index++;
      });
    });
    socket.onDisconnect((_) => print('disconnect'));

  }

  String getLastCoordinate(List<dynamic> configTags){
    return configTags.last.keys.first.toString();
  }

  @override
  void initState() {
    connectAndListen();
    super.initState();
  }

  @override
  void dispose() {
    streamSocket.dispose();
    super.dispose();
  }
}
