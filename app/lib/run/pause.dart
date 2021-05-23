import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app/config/config.dart';
import 'package:app/nav/launcher.dart';
import 'package:app/run/showdata.dart';
import 'package:app/run/startrun.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/rundata/datarunner.dart';
import 'package:app/ui/running.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';

class Pause extends StatefulWidget {
  final String kmData;
  final String timeData;
  final String myType;
  final int id;

  const Pause({Key key, this.kmData, this.timeData,this.myType,this.id}) : super(key: key);
  @override
  _PauseState createState() => _PauseState();
}

class _PauseState extends State<Pause> {
  Completer<GoogleMapController> _controller = Completer();
  var theKm = "0";
  var theTime;
  var hh;
  var mm;
  var ss;
  var theLat = 16.4464643;
  var theLng = 0.00;
  var sum = "";
  var consum;
  var sumk = 0.0;
  var sumkm = "0";
  var disAll = 0.0;

  var totalTime;
  var douTime;
  var cals ;
  int calories = 0;
  SystemInstance _systemInstance = SystemInstance();

  List _listSum = List();

  Map map = {};
  var distanceMessage = "";
  FileUtil _fileUtil = FileUtil();
  var userId;
  var theType;
  List<DataRunner> _listData = [];
  List aaa = List();
  List bbb = List();
  List load = List();
  var _loadData;

  DateTime _dateTime = new DateTime.now();
  var date;
  var allRunId;
  var myId;
  var img;
  var name;
  var nameAll;
  var result = "0";
  var myTid;

  var timer;
  var dd = Duration(hours: 0,minutes: 0,seconds: 0);


  @override
  void initState(){
    print(theKm);
    allRunId = widget.id;
    SystemInstance systemInstance = SystemInstance();
    myId = systemInstance.userId;
    _fileUtil.readFile().then((value){
      this.userId = value;
      print("UserID:${userId}");
    });
    super.initState();
    loadData1();
    calculate();
    _getData();
    getAll();
    getImg();
    getAllName();
    getName();
    // saveSuccess();
  }

  Future _getData() async {
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_data/show?userId=${myId}&id=${allRunId}',headers: header);
    var _data = jsonDecode(data.body);
    print("_data$_data");
    for (var i in _data) {
      DataRunner dataRunner = DataRunner(
        i["did"],
        i["userId"],
        i["id"],
        i["km"],
        i["time"],
        i["type"],
        i["dateNow"],
      );
      aaa.add(i["time"]);
      bbb.add(i["km"]);
      _listData.add(dataRunner);
      print(aaa);
      print(bbb);
    }
    for (var i in aaa) {
      var hh = i.substring(0, 2);
      var mm = i.substring(3, 5);
      var ss = i.substring(6, 8);

      var h = int.parse(hh);
      var m = int.parse(mm);
      var s = int.parse(ss);

      var dur = Duration(hours: h,minutes: m,seconds: s);
      print("dur$dur");
      dd = dd + dur;
      var d = dd.toString();
      timer = d.substring(0,7);
      print('timer$timer');

      // var htos = h * 60 * 60;
      // var mtos = m * 60;
      // var total = htos + mtos + s;

      var hhTheTime = theTime.substring(0,2);
      var mmTheTime = theTime.substring(3, 5);
      var ssTheTime = theTime.substring(6, 8);

      var hTheTime = int.parse(hhTheTime);
      var mTheTime = int.parse(mmTheTime);
      var sTheTime = int.parse(ssTheTime);

      var indur = Duration(hours: hTheTime,minutes: mTheTime,seconds: sTheTime);
      print("indur$indur");

      // var htosTheTime = hTheTime * 60 * 60;
      // var mtosTheTime = mTheTime * 60;
      // var totalTheTime = htosTheTime + mtosTheTime + sTheTime;
      var insum = dd + indur;
      var de = insum.toString();
      var dee = de.substring(0,7);
      var deee = "0$dee";
      sum = deee;

    }
    print("sum$sum");
    // var sstom = sum / 60;
    // var ssstom = "0${sstom}0";
    // var mmm = ssstom.toString().substring(0, 2);
    // var sss = ssstom.toString().substring(3, 5);
    // var ssss = "${sss}";
    // var stoi = double.parse(ssss);
    // var stos = stoi * 60;
    // var datas = stos.toStringAsFixed(0);
    // consum = "00:${mmm}:${datas}";

    for (var i in bbb) {
      var k = double.parse(i);
      var zzz = NumberFormat('#0.0#');
      sumk = sumk + k;
      print("k$k");
      print("sumk $sumk");
      sumkm = zzz.format(sumk);
    }
    print(sumkm);
    setState(() {

    });
    return _listData;
  }

  void calculateCals(){
    var km = double.parse(theKm);
    cals = 68.83*km*1.036;
    calories = cals.toInt();
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
    http.post('${Config.API_URL}/save_position/show?userId=$myId&id=$allRunId&dateNow=$date', headers: header,body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['data'];
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
      setState(() {
      });
      return distanceMessage;
    });

  }

  void loadData(){
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/total_data/show?userId=$myId&id=$allRunId',headers: header).then((res){
      Map resMap = jsonDecode(res.body) as Map;
      // print("load:${resMap}");
      var data = resMap['data'];
      for(var i in data){
        var _data = i['tid'];
        // load.add(_data);
        _loadData = _data;
      }
      // print(_loadData);
    });
    setState(() {

    });
  }
  Future loadData1()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/total_data/show?userId=$myId&id=$allRunId',headers: header);
    var _data = jsonDecode(data.body);
    // print("loadD:${_data}");
    for(var i in _data){
      print(i);
      var tid = i['tid'];
      // load.add(tid);
      _loadData = tid;
    }
    print("_loadData$_loadData");
    return _loadData;
  }
  Future getAll()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show_id?id=$allRunId',headers: header);
    var _data = jsonDecode(data.body);
    for(var i in _data){
      var dis = i['distance'];
      disAll = double.parse(dis);
    }
    print("disdis$disAll");
    return disAll;
  }
  Future getAllName()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show_id?id=$allRunId',headers: header);
    var _data = jsonDecode(data.body);
    for(var i in _data){
      nameAll = i['nameAll'];
    }
    print('nameAll$nameAll');
    return nameAll;
  }
  Future getImg()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$myId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    for(var i in sum){
      print(i);
      img = i['imgProfile'];
    }
    print("img$img");
    setState(() {

    });
    return img;
  }
  Future getName()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$myId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    for(var i in sum){
      print(i);
      name = i['name'];
    }
    print("name$name");
    setState(() {

    });
    return name;
  }

  void saveToData(){
    print("sumK$sumkm");
    print("dis$theKm");
    if(sum == ""){
      print("null");
      sum = theTime;
    }else{
      sum = sum;
    }
    var inkm = double.parse(sumkm);
    var inthe = double.parse(theKm);
    print("inkm$inkm");
    print("inthe $inthe");
    var mk = inkm + inthe;
    var kk = mk.toStringAsFixed(2);
    result = kk.toString();
    print("result $result");
    print(_loadData);
    if(_loadData !=null){
      print("notnull:${_loadData}");
      print("sum$sum");
      Map params = Map();
      params['tid'] = _loadData.toString();
      params['userId']= userId.toString();
      params['id'] = allRunId.toString();
      params['km'] = result.toString();
      params['time'] = sum.toString();
      params['type'] = theType.toString();
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      http.post('${Config.API_URL}/total_data/update',headers: header,body: params).then((res){
        Map resMap = jsonDecode(res.body) as Map;
        print(resMap);
      });
    }else{
      print("null:${_loadData}");
      print("sum$sum");
      Map params = Map();
      params['userId']= userId.toString();
      params['id'] = allRunId.toString();
      params['km'] = result.toString();
      params['time'] = sum.toString();
      params['type'] = theType.toString();
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      http.post('${Config.API_URL}/total_data/update',headers: header,body: params).then((res){
        Map resMap = jsonDecode(res.body) as Map;
        print("resres$resMap");
        myTid = resMap['tid'];
        print("mymy$myTid");
        saveInData();
      });
    }

    // saveInData();
    setState(() {

    });
  }
  void saveInData(){
    print("mytid$myTid");
    Map params = Map();
    params['userId'] = userId.toString();
    params['id'] = allRunId.toString();
    params['tid'] = myTid.toString();
    params['km'] = theKm.toString();
    params['time'] = theTime.toString();
    params['type'] = theType.toString();
    params['dateNow'] = date.toString();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/test_data/save',headers: header,body: params).then((res){
      Map resMap = jsonDecode(res.body) as Map;
      print(resMap);
    });
    setState(() {

    });
  }
  void saveSuccess(){
    // print("distance$distanceMessage");
    // print("disAll$disAll");
    print(result);
    var res = double.parse(result);
    // var dis = double.parse(result);
    // print(dis);
    if(res >= disAll){
      print('dis');
      print("sum$sum");
      Map params = Map();
      params['userId']= userId.toString();
      params['name'] = name.toString();
      params['nameAll'] = nameAll.toString();
      params['km'] = result.toString();
      params['time'] = sum.toString();
      params['type'] = theType.toString();
      params['imgRanking'] = img.toString();
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      http.post('${Config.API_URL}/ranking/save',headers: header,body: params).then((res){
        Map resMap = jsonDecode(res.body) as Map;
        print(resMap);
      });
    }else{
      print("dhdh");
    }
  setState(() {

  });
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('หยุดวิ่งแล้ว'),
        actions: [

          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด',),
          )
        ],
      )
  );

  removeList() async{
    print("remove");
    print(allRunId);
    print(userId);
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/save_position/remove?id=${allRunId}&userId=${userId}',headers: header);
    print(data);
    var jsonData = json.decode(data.body);
    if(jsonData['status'] == 0){
      print("remove แล้ว");
      setState(() {

      });
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    date = ("${_dateTime.day}/${_dateTime.month}/${_dateTime.year}");
    theKm = widget.kmData;
    theTime = widget.timeData;
    theType = widget.myType;
    print("tpe:${theType}");
    calculateCals();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('พัก'),
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 380,
                width: 300,
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(16.4329112, 102.823361),
                    zoom: 16,
                  ),

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),

              ),

              Container(
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                 child: Column(
                   children: [
                     Row(
                       children: <Widget>[
                         Expanded(
                           child: Text('${theKm}', textAlign: TextAlign.center,style: TextStyle(fontSize: 35),),

                         ),
                         Expanded(
                           child: Text('${calories}', textAlign: TextAlign.center,style: TextStyle(fontSize: 35),),

                         ),
                         Expanded(
                           child: Text('${theTime}',textAlign: TextAlign.center,style: TextStyle(fontSize: 28),),
                         ),
                       ],
                     ),
                     Row(
                       children: <Widget>[
                         Expanded(
                           child: Text('กิโลเมตร', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),

                         ),
                         Expanded(
                                 child: Text('แคลอรี่', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),

                               ),
                         Expanded(
                           child: Text('เวลา',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                         ),
                       ],
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 20),
                     ),
                     // Row(
                     //   children: <Widget>[
                     //
                     //     Expanded(
                     //       child: Text('0 ม.', textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
                     //     ),
                     //     Expanded(
                     //       child: Text('--',textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
                     //     ),
                     //   ],
                     // ),
                     // Row(
                     //   children: <Widget>[
                     //     Expanded(
                     //       child: Text('แคลอรี่', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                     //
                     //     ),
                     //     Expanded(
                     //       child: Text('วิ่งไต่ระดับ', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                     //     ),
                     //     Expanded(
                     //       child: Text('ครั้งต่อนาที',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                     //     ),
                     //   ],
                     // ),
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
                                 icon: Icon(Icons.stop),
                                 color: Colors.white,
                                 iconSize: 100,
                                 onPressed: () {
                                   saveToData();
                                   saveInData();
                                   saveSuccess();
                                   removeList();
                                   showCustomDialog(context);
                                     // Navigator.pushReplacement(
                                     //     context,
                                     //     MaterialPageRoute(builder: (context) => ShowDataScreen(km: distanceMessage,myCal: calories,time: consum,)));
                                   Navigator.pop(context);
                                   Navigator.pop(context);
                                   Navigator.pop(context);
                                   Navigator.pop(context);
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
            ],
          ),
        ),
      ),

    );
  }

}

