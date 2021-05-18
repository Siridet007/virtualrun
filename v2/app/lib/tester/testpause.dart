import 'dart:convert';
import 'dart:math';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class TestPause extends StatefulWidget {
  @override
  _TestPauseState createState() => _TestPauseState();
}

class _TestPauseState extends State<TestPause> {

  SystemInstance _systemInstance = SystemInstance();

  List _listSum = List();
  Map map = {};
  var distanceMessage = "";

  FileUtil _fileUtil = FileUtil();
  var userId;
  var theTime;
  var theType;

  @override
  void initState(){

    _fileUtil.readFile().then((value){
      this.userId = value;
      print("UserID:${userId}");
    });
    //cals = 68.83*3.02*1.306;
    // print(theKm);
    super.initState();
    calculate();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var total = 12742 * asin(sqrt(a));
    return total;
  }

  void calculate() {
    Map params = Map();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/save_runner/load', headers: header,body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['data'];
      for (var i in data) {
        var lat = i['lat'];
        var lng = i['lng'];
        map = {'lat': lat, 'lng': lng};
        // print("Map:${map}");
        _listSum.add(map);
        // resLat = i['lat'].toStringAsFixed(7);
        // resLng = i['lng'].toStringAsFixed(7);
      }
      //print(_listSum);
      // print(_listSum.runtimeType);
      double totalDistance = 0;
      for (var i = 0; i < _listSum.length - 1; i++) {
        totalDistance +=
            calculateDistance(_listSum[i]["lat"], _listSum[i]["lng"],
                _listSum[i + 1]["lat"], _listSum[i + 1]["lng"]);
      }
      distanceMessage = totalDistance.toStringAsFixed(2);
      // paceDis = double.parse(distanceMessage);
      // print("fsdf${paceDis}");
      setState(() {

        //print('${distanceMessage}Km');
      });
      return distanceMessage;
    });

  }
  void saveToData(){
    Map params = Map();
    params['userId'] = userId.toString();
    params['km'] = distanceMessage.toString();
    params['time'] = theTime.toString();
    params['type'] = theType.toString();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/data_user/save',headers: header,body: params).then((res){
      Map resMap = jsonDecode(res.body) as Map;
      print(resMap);
    });
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
