import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:permission/permission.dart';
import 'package:provider/provider.dart';

import 'package:app/config/config.dart';
import 'package:app/gps/stopwatch.dart';
import 'package:app/run/pause.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/running.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
class StartRun extends StatefulWidget {
  final int startId;
  final String myType;

  const StartRun({Key key, this.startId,this.myType}) : super(key: key);
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<StartRun> {
  var startTime = 0;

  SystemInstance _systemInstance = SystemInstance();

  var distanceMessage = "";

  Location _location = Location();


  String _lng = "";
  String _lat = "";



  Map map = {};
  Map sum = {};

  bool startbutton = true;
  bool stopbutton = true;
  bool resetbutton = true;
  String timer = "00:00:00";
  var swatch = Stopwatch();
  String pace = "_'__''";

  // var paceTime;
  // var paceDis;
  // var paceCal;

  final dur = const Duration(seconds: 1);
  int theStartId;
  FileUtil _fileUtil = FileUtil();
  var userId;
  var dataCal;
  var theType;
  var myId;
  var allRunId;
  var id;
  var myDate;
  StreamSubscription<LocationData> locationSubscription;
  double _speed = 0.0;
  var mySpeed;
  @override
  void initState() {
    // TODO: implement initState
    SystemInstance systemInstance = SystemInstance();
    myId = systemInstance.userId;
    allRunId = widget.startId;
    DateTime dateNow = DateTime.now();
    myDate = "${dateNow.day}/${dateNow.month}/${dateNow.year}";
    print("aidid = $allRunId");
    calculate();
    _fileUtil.readFile().then((value){
      this.userId = value;
      print("UserID:${userId}");
    });
    locationSubscription = _location.onLocationChanged().listen((locationData) {
      String lng = "${locationData.longitude}";
      String lat = "${locationData.latitude}";
      // _onSpeedChange(locationData.speed != null && locationData.speed * 3600 / 1000 > 0 ? (locationData.speed * 3600 / 1000) : 0);

      if (lng != _lng && lat != _lat) {
        print("on location change...");
        print("data lat ${locationData.latitude} .....");
        print("data lng ${locationData.longitude} .....");
        _lng = lng;
        _lat = lat;
        calculate();
        Map params = Map();
        print("ccc");
        params['lat'] = lat.toString();
        params['lng'] = lng.toString();
        params['userId'] = myId.toString();
        params['id'] = allRunId.toString();
        params['dateNow'] = myDate.toString();
        Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
        http.post('${Config.API_URL}/save_position/save',headers: header, body: params).then((res) {
          Map resMap = jsonDecode(res.body) as Map;
          print(resMap);
        });
      }
    });
    super.initState();
  }
  // void calculatePace(){
  //   try{
  //     paceDis = int.parse(distanceMessage);
  //     paceTime = int.parse(timer);
  //     //paceCal = (paceTime/paceDis);
  //     print(paceTime);
  //     print(paceDis);
  //   }on FormatException {
  //     print('Format error!');
  //     print(paceTime);
  //     print(paceDis);
  //   }
  // }
  // void _onSpeedChange(double newSpeed) {
  //   setState(() {
  //     _speed = newSpeed;
  //     mySpeed = _speed.toStringAsFixed(2);
  //   });
  //   print("_speed $mySpeed");
  // }

//-------------------------calculate distance---------------------------------//
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
    print('aaa');

    Map params = Map();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/save_position/show?userId=$myId&id=$allRunId&dateNow=$myDate', headers: header, body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['data'];
      List _listSum = List();
      print(data);
      for (var i in data) {
        var lat = i['lat'];
        var lng = i['lng'];
        map = {'lat': lat, 'lng': lng};
        _listSum.add(map);
      }
      double totalDistance = 0;
      for (var i = 0; i < _listSum.length - 1; i++) {
        totalDistance +=
            calculateDistance(_listSum[i]["lat"], _listSum[i]["lng"],
                _listSum[i + 1]["lat"], _listSum[i + 1]["lng"]);
      }
      distanceMessage = totalDistance.toStringAsFixed(2);
      // return distanceMessage;
    });
  }
//----------------------------------------------------------------------------//



//-----------------------------stopwatch--------------------------------------//
  void starttimer(){
    Timer(dur, keeprunning);
  }
  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
    }
    setState(() {
      timer = swatch.elapsed.inHours.toString().padLeft(2,"0")+":"+
          (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0")+":"+
          (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }
  void startstopwatch(){
    setState(() {
      //calculate();
      stopbutton = false;
      startbutton = false;
    });
    swatch.start();
    starttimer();
  }
  void stopstopwatch(){
    setState(() {
      stopbutton = true;
      resetbutton = false;
    });
    swatch.stop();
  }
  void resetstopwatch(){
    setState(() {
      startbutton = true;
      resetbutton = true;
    });
    swatch.reset();
    timer = "00:00:00";
  }
//----------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    theType = widget.myType;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('เริ่ม'),
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

      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('${timer}', textAlign: TextAlign.center,style: TextStyle(fontSize: 50),),

                    ),
                    // Expanded(
                    //   child: Text('0', textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
                    // ),
                    // Expanded(
                    //   //time / distance = pace----------------
                    //   child: Text("${pace}",textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
                    // ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('เวลา', textAlign: TextAlign.center,style: TextStyle(fontSize: 30),),

                    ),
                    // Expanded(
                    //   child: Text('ครั้งต่อนาที', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                    // ),
                    // Expanded(
                    //   child: Text('เพซ',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                    // ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),

                    Text('${distanceMessage}',style: TextStyle(fontSize: 50),),
                    Text('กิโลเมตร',style: TextStyle(fontSize: 30),),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),

                    // Text('${mySpeed}',style: TextStyle(fontSize: 50),),
                    // Text('อัตราเร็ว',style: TextStyle(fontSize: 30),),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Divider(
                  height: 20,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey[800],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.play_arrow),
                            color: Colors.white,
                            iconSize: 100,
                            onPressed: () {
                              startstopwatch();
                              locationSubscription.resume();

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => Pause()));
                             },

                          ),
                        ),
                      ),


                    ),
                    Expanded(
                      child: Container(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.pause),
                            color: Colors.white,
                            iconSize: 100,
                            onPressed: () {
                              stopstopwatch();
                              locationSubscription.pause();
                              print("type:${theType}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Pause(kmData: distanceMessage,timeData: timer,myType: theType,id: allRunId,)));
                            },
                          ),
                        ),
                      ),


                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}