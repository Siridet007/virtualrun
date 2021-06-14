import 'package:app/system/SystemInstance.dart';
import 'package:app/test/chart.dart';
import 'package:app/ui/news.dart';
import 'package:app/ui/ranking.dart';
import 'package:app/ui/runner.dart';
import 'package:app/user/login.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/profile.dart';
import '../ui/tournament.dart';

class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  SystemInstance systemInstance = SystemInstance();
  SharedPreferences sharedPreferences;
  FileUtil _fileUtil = FileUtil();
  var id;
  var userId;
  SystemInstance _systemInstance = SystemInstance();
  var stat;

  List<Widget> _pageWidget = <Widget>[
    Tournament(),
    //StopWatch(),
    //Running(),
    //LocationScreen(),
    Runner(),
    // ChartScreen(),
    //MapSample(),
    //Tracking(),
    ProFile(),

    // Report(),
    //TabBarScreen(),
    RankingScreen(),
    // TestRankingScreen(),
    // DataFun(),
    // TestPro(),
    NewsScreen(),

    // Setting(),
  ];

  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.list),
      title: Text('รายการวิ่ง'),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.running),
      title: Text('วิ่ง'),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.userAlt),
      title: Text('บัญชีของฉัน'),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.star),
      title: Text('จัดอันดับ'),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.newspaper),
      title: Text('ข่าวสาร'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _fileUtil.readFile().then((id) {
      this.userId = id;
      print('id ${userId}');
      systemInstance.token = sharedPreferences.getString("token");
      systemInstance.userId = userId;
    });
    checkToken();
    super.initState();
  }

  checkToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
