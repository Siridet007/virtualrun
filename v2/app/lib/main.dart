import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'nav/launcher.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black54,
        primaryColor: Colors.pink,
        accentColor: Colors.pink[300],
        textTheme: TextTheme(body1: TextStyle(color: Colors.red)),
      ),
      home: SplashScreen(),
      routes: {'/Launcher': (BuildContext context) => Launcher()},
    ));

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State {
  _startTimeMain() async {
    Timer(Duration(seconds: 1), _gotoMain);
  }

  void _gotoMain() {
    Navigator.of(context).pushReplacementNamed('/Launcher');
  }

  @override
  void initState() {
    _startTimeMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.pink, Colors.red],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.running,
              size: 200,
              color: Colors.white,
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Text(
              'vRun',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }
}
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Google Maps Demo',
//       //home: Login(),
//       home: First(),
//       routes: {'/Launcher': (BuildContext context) => Launcher()},
//     );
//   }
// }
//
// class First extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _First();
//   }
// }
//
// class _First extends State {
//   /*SystemInstance _systemInstance = SystemInstance();
//
//   @override
//   void initState() {
//     Map header = {"Authorization": "Bearer ${_systemInstance.token}"};
//     http.post("${Config.API_URL}/fun_run/check_fun", headers: header).then((res){
//       print(res.body);
//     });
//     super.initState();
//   }*/
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         backgroundColor: Colors.black54,
//         primaryColor: Colors.pink,
//         accentColor: Colors.pink[300],
//         textTheme: TextTheme(body1: TextStyle(color: Colors.red)),
//       ),
//       title: 'First Flutter App',
//       initialRoute: '/',
//       // สามารถใช้ home แทนได้
//       routes: {
//         Launcher.routeName: (context) => Launcher(),
//       },
//     );
//   }
// }
