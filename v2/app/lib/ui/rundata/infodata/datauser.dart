import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/widget/tile_row.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataUserScreen extends StatefulWidget {
  final int userId;

  const DataUserScreen({Key key, this.userId}) : super(key: key);
  @override
  _DataUserScreenState createState() => _DataUserScreenState();
}

class _DataUserScreenState extends State<DataUserScreen> {
  SystemInstance _systemInstance = SystemInstance();
  var id;
  var name = "";
  var tel = "";


  void getData(){
    print(id);
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/user_profile/show?userId=$id', headers: header).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      print(resMap);
      var data = resMap['data'];
      print(data);
      for(var i in data){
        print(i);
        name = i['name'];
        tel = i['tel'];
      }
      setState(() {
        name = name;
        tel = tel;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    id = widget.userId;
    print("id$id");
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อมูลการติดต่อ'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("$name", style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ),
          Center(
            child: Card(
              child: ListTile(
                leading: Icon(Icons.tablet_mac),
                title: Text("$tel", style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ),
        ],
      )
    );
  }
}
