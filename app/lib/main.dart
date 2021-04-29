import 'package:flutter/material.dart';

import 'nav/launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      //home: Login(),
      home: First(),
    );
  }
}

class First extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _First();
  }
}

class _First extends State {
  /*SystemInstance _systemInstance = SystemInstance();

  @override
  void initState() {
    Map header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post("${Config.API_URL}/fun_run/check_fun", headers: header).then((res){
      print(res.body);
    });
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black54,
        primaryColor: Colors.pink,
        accentColor: Colors.pink[300],
        textTheme: TextTheme(body1: TextStyle(color: Colors.red)),
      ),
      title: 'First Flutter App',
      initialRoute: '/', // สามารถใช้ home แทนได้
      routes: {
        Launcher.routeName: (context) => Launcher(),
      },
    );
  }
}
