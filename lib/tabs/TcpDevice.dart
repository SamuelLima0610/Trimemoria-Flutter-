import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class TcpDevice extends StatefulWidget {
  @override
  _TcpDeviceState createState() => _TcpDeviceState();
}

class _TcpDeviceState extends State<TcpDevice> {

  final _wifiController = TextEditingController();
  final _passwordController = TextEditingController();
  final _stateForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: _stateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _wifiController,
                decoration: InputDecoration(
                    labelText: 'WiFi',
                    labelStyle: TextStyle(
                        color: Color(0xFFFF8306)
                    )
                ),
                // ignore: missing_return
                validator: (value){
                  if(value.isEmpty) return "O campo deve ser preenchido";
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                        color: Color(0xFFFF8306)
                    )
                ),
                // ignore: missing_return
                validator: (value){
                  if(value.isEmpty) return "O campo deve ser preenchido";
                },
                obscureText: true,
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 45.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFF8306),
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if(_stateForm.currentState.validate()){
                            Socket socket = await Socket.connect('192.168.4.1', 555);
                            final snackBar = SnackBar(
                              content: Text(
                                  "Enviado"
                              ),
                              duration: Duration(seconds: 5),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            socket.add(utf8.encode('${_wifiController.text};${_passwordController.text}'));
                            socket.close();
                          }
                        },
                        child: Text(
                            "Enviar",
                            style: TextStyle(color: Colors.white,fontSize: 22.0)
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFF8306),
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _wifiController.text = '';
                            _passwordController.text = '';
                          });
                        },
                        child: Text(
                            'Limpar',
                            style: TextStyle(color: Colors.white,fontSize: 22.0)
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}
