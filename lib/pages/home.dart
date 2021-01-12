import 'package:flutter/material.dart';
import 'package:trimemoria/pages/config_game.dart';
import 'package:trimemoria/pages/config_page_view.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trimemória"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
            children: [
              Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.play_circle_filled),
                        title: Text("Jogue e Teste sua memória"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('JOGAR'),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ConfigGame()
                                  )
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.assignment_ind),
                        title: Text("Configurar"),
                        subtitle: Text(
                            "Configure os temas, configurações de dispositivos "
                            "e conectar ao dispovito, para uma melhor experiência do jogo"
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('CONFIGURAR'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ConfigPageView()
                                )
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

}
