import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;
  SystemInstance _systemInstance = SystemInstance();
  List<DataRunner> _dataFun = [];


  Future _getDataFun() async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/data_user/load',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    for(var i in _data){
      print(i);
      DataRunner dataRunner = DataRunner(
        i["did"],
        i["userId"],
        i["km"],
        i["time"],
        i["type"],
      );

      _dataFun.add(dataRunner);
    }
    print("Run: ${_dataFun}");
    return _dataFun;
  }

  @override
  void initState(){
    _tabController = new TabController(length: 4, vsync: this);
  }
  @override
  void dispose(){
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sffsf'),
        bottom: new TabBar(
          controller: _tabController,
            tabs: [
              new Tab(icon: Icon(Icons.home), text: 'Home'),
              new Tab(icon: Icon(Icons.star), text: 'Feed'),
              new Tab(icon: Icon(Icons.face), text: 'Profile'),
              new Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ]
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
          children: null,
      ),
    );
  }
}
class DataRunner {
  final int did;
  final int userId;
  final String km;
  final String time;
  final String type;

  DataRunner(this.did, this.userId, this.km, this.time, this.type);
}
const List<DataRunner> dataRunners =  const <DataRunner>[
];
