import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/rundata/datarunner.dart';
import 'package:app/ui/runner.dart';
import 'package:app/ui/running.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';


class KilometerScreen extends StatefulWidget {
  final int id;
  final String type;
  final String km;
  final String dateS;
  final String dateE;

  const KilometerScreen({Key key, this.id,this.type,this.km,this.dateS,this.dateE}) : super(key: key);
  @override
  _KilometerScreenState createState() => _KilometerScreenState();
}

class _KilometerScreenState extends State<KilometerScreen> {
  SystemInstance _systemInstance = SystemInstance();
  var userId;
  var theType;
  var aid;
  var distance;
  var theKm;
  List aaa = List();
  List km = List();
  List time = List();
  List<DataRunner> _list = List();
  List<DataRunner> _listData = [];
  var sum = 0;
  var consum = "00:00:00";
  var sumk = 0.0;
  var tid;
  var myKmm;
  var myDateS;
  var myDateE;
  var conS;
  var conE;
  final _date = new DateTime.now();
  var date2s;
  var s2date;
  bool _isLoading = true;
  List<DataRun> dataRuns = [];
  bool date = false;

  void initState(){
    SystemInstance systemInstance = SystemInstance();
    userId = systemInstance.userId;
    theType = widget.type;
    aid = widget.id;

    print("aid$aid");
    _getDataDate();
    _getNewData();

    super.initState();
  }


  Future _getDataDate()async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/test_run/test_show?userId=${userId}', headers: header);
    if (data.statusCode == 200) {
      _isLoading = false;
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      // print(_data);
      // print(sum);
      for (var i in sum) {
        myDateS = i['dateStart'];
        myDateE = i["dateEnd"];

      }
      print(myDateS);
      print(myDateE);
      conS = new DateFormat('dd/mm/yyyy').parse(myDateS);
      conE = new DateFormat('dd/mm/yyyy').parse(myDateE);
      date2s = ('${_date.day}/${_date.month}/${_date.year}');
      s2date = new DateFormat('dd/mm/yyyy').parse(date2s);
      print(conS);
      print(conS);
      print(date2s);
      print(s2date);
      if((s2date==conS || s2date.isAfter(conS)) && (s2date==conE || s2date.isBefore(conE))){
        date = true;
        setState(() {

        });
      }else{
        date = false;
        setState(() {

        });
      }
      setState(() {

      });
      return dataRuns;
    } else {
      _isLoading = false;
      setState(() {

      });
    }
  }

  Future _getNewData() async {
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/total_data/show?userId=${userId}&id=${aid}',headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    for (var i in _data) {
      print(i);
      DataRunner dataRunner = DataRunner(
        i["tid"],
        i["userId"],
        i["id"],
        i["km"],
        i["time"],
        i["type"],
        i["dateNow"],

      );
      tid = i['tid'];
      time.add(i["time"]);
      myKmm = i['km'];
      km.add(i["km"]);
      _listData.add(dataRunner);
    }
    print("Run: ${_listData}");
    print(time);
    print(km);
    for (var i in km) {
      print(i);
      var k = double.parse(i);
      sumk = sumk + k;
    }
    print(sumk);
    print(sum.runtimeType);
    print(sumk.runtimeType);
    setState(() {
      sum = sum;
      sumk = sumk;
    });
    _getData();
    return _listData;
    // return Future.value(_listData);
  }

  Future _getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_data/show_tid?tid=$tid',headers: header );
    var _data = jsonDecode(data.body);
    print("Data:${_data}");
    for (var i in _data){
      print("I:${i}");
      DataRunner dataRunner = DataRunner(
        i["did"],
        i["userId"],
        i["id"],
        i["km"],
        i["time"],
        i["type"],
        i["dateNow"],
      );

      aaa.add(i["km"]);
      _list.add(dataRunner);
      print("flfl${_list}");
    }
    setState(() {

    });

    print(_list);
    return _list;
  }

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ท่านวิ่งครบตามระยะทางแล้ว'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );

  Future showCustomDialogDate(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ไม่ตรงตามวันเวลาที่กำหนด'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );


  @override
  Widget build(BuildContext context) {
    distance = widget.km;
    print('$date');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('km'),
        actions: [
          if(date == false)...[
            IconButton(
                icon: Icon(Icons.forward),
                onPressed: (){
                  showCustomDialogDate(context);
                }
            ),
      ]else...[
            _list.isEmpty ?
            IconButton(
              icon: Icon(Icons.forward),
              onPressed: (){
                print("วิ่งใหม่");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Running(isType:theType,idrunner: aid,)));
              },
            ):IconButton(
              icon: Icon(Icons.forward),
              onPressed: (){
                var theDis = double.parse(distance);
                var myKm = double.parse(myKmm);
                // myKm = 5;
                print("the$theDis");
                print("my$myKm");
                if(myKm < theDis){
                  print("วิ่งต่อ");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Running(idrunner: aid,isType:theType)));
                }else{
                  showCustomDialog(context);
                }
              },
            ),
          ]

          ],

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
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
              child: Text(
                'รายละเอียดการวิ่ง',
                style: TextStyle(fontSize: 20,color: Colors.black),
              ),
          ),
          Container(
            child: _list.isEmpty ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: ListTile(
                  leading: Icon(Icons.directions_run),
                  title: Text('ท่านยังไม่ได้เริ่มวิ่งรายการนี้'),
                  subtitle: Text('ระยะทางที่วิ่งได้ 0 กิโลเมตร'),
                  // onTap: (){
                  //   print("empty");
                  //
                  // },
                ),
          ):ListView.builder(
              shrinkWrap: true,
              // itemBuilder: getItem ,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                var item = _list[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: ListTile(
                      leading: Icon(Icons.directions_run),
                      title: Text('วันที่วิ่ง ${_list[index].dateNow}'),
                      subtitle: Text(' ระยะทางที่วิ่งได้ ${_list[index].km} กิโลเมตร \n ใช้เวลาไป ${_list[index].time}'),
                      // onTap: () {
                      //   int aaId = item.id;
                      //   print("allRunId = $aaId");
                      //   theKm = item.km;
                      //   // var theDis = 10;
                      //   var theDis = double.parse(distance);
                      //   var myKm = double.parse(theKm);
                      //   // myKm = 5;
                      //   if(myKm < theDis){
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //           Running(idrunner: aaId,isType:theType)));
                      //   }else{
                      //   showCustomDialog(context);
                      //   }
                      // },
                    ),
                );
              },
            ),),
           Padding(
              padding: const EdgeInsets.only(top: 50),
           ),
          Container(
            child: _listData.isEmpty ? Padding(
              padding: const EdgeInsets.only(top: 10),
            ):ListView.builder(
                shrinkWrap: true,
                // itemBuilder: getItem ,
                itemCount: _listData.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = _listData[index];
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: ListTile(
                      leading: Icon(Icons.check),
                      title: Text('ระยะทางที่ต้องวิ่ง ${distance} กิโลเมตร'),
                      subtitle: Text('ระยะทางที่วิ่งได้ทั้งหมด ${_listData[index].km} กิโลเมตร \nใช้เวลาไปทั้งหมด ${_listData[index].time}'),
                    ),
                  );
                },
          ),),
        ],
      ),




      // _listData.isEmpty ? Card(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //   ),
      //   child: ListTile(
      //     leading: Icon(Icons.directions_run),
      //     title: Text('ระยะทาง $distance กิโลเมตร'),
      //     subtitle: Text('ระยะทางที่วิ่งได้ 0 กิโลเมตร'),
      //     onTap: (){
      //       print("empty");
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (BuildContext context) =>
      //                   Running(isType:theType,idrunner: aid,)));
      //     },
      //   ),
      // ) : ListView.builder(
      //     shrinkWrap: true,
      //     // itemBuilder: getItem ,
      //     itemCount: _listData.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       var item = _listData[index];
      //       return Card(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //         child: ListTile(
      //           leading: Icon(Icons.directions_run),
      //           title: Text('ระยะทาง $distance กิโลเมตร'),
      //           subtitle: Text(' ระยะทางที่วิ่งได้  ${sumk} กิโลเมตร'),
      //           onTap: () {
      //             int aaId = item.id;
      //             print("allRunId = $aaId");
      //             theKm = item.km;
      //             // var theDis = 10;
      //             var theDis = double.parse(distance);
      //             var myKm = double.parse(theKm);
      //             // myKm = 5;
      //             if(myKm < theDis){
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (BuildContext context) =>
      //                           Running(idrunner: aaId,isType:theType)));
      //             }else{
      //               showCustomDialog(context);
      //             }
      //           },
      //         ),
      //       );
      //     }),
    );
  }
}
