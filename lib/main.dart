import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trimemoria/pages/design.dart';
import 'package:trimemoria/pages/home.dart';

Future main() async {
  //método para garantir que os widgets tenham sido construidos para poder fazer
  //a mudança de orientação
  WidgetsFlutterBinding.ensureInitialized();
  //coloca a orientação para landscape
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFFFF8306)),
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

}




