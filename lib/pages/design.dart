import 'package:flutter/material.dart';

class Design extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;
    return Container(
      color: Color(0xFF272837),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                    "Trimemória",
                    style: TextStyle(
                      color: Color(0xFFFF8306),
                      decoration: TextDecoration.none
                    ),
                ),
                Text(
                    "Lenda",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color(0xFFFF8306),
                    ),
                )
              ],
            ),
            Wrap(
              runSpacing: 16,
              children: [
                modeButton("Jogar", "Teste sua memória", Icons.gamepad,
                    Color(0xFFFF8306), width,(){}),
                modeButton("Configurações", "Venha tematizar o seu jogo", Icons.build,
                    Color(0xFFFF8306), width,(){})
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector modeButton(
      String title,
      String subtitle, IconData icon,
      Color color, double width, Function onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign:  TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 18.0
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Text(
                      subtitle,
                      textAlign:  TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 12.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Icon(icon,size: 30, color: Colors.white,)
            )
          ],
        ),
      ),
    );
  }
}
