import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/profile.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'funrun.dart';

class OldListScreen extends StatefulWidget {
  const OldListScreen({Key key}) : super(key: key);

  @override
  _OldListScreenState createState() => _OldListScreenState();
}

class _OldListScreenState extends State<OldListScreen> {
  SystemInstance _systemInstance = SystemInstance();
  List<Run> runs = [];
  var userId;
  var aaid;
  FileUtil _fileUtil = FileUtil();
  var stat = "";
  var nameAll;
  var dis;
  var type;
  var dates;
  var datee;
  var img;
  var price;
  bool _isLoading = true;
  List _list = List();
  final _date = new DateTime.now();
  var date2s;
  var s2date;

  Future getMyData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['data'];
    for(var i in sum){
      print(i);
      ProfileData(
          i['userId'],
          i['userName'],
          i['passWord'],
          i['au'],
          i['name'],
          i['tel'],
          i['imgProfile']
      );
      stat = i['au'];
    }
    print(stat);
    showList();
    checkId();
    return stat;
  }

  Future checkId()async{
    if(stat == "Admin"){

    }else{
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_run/show_run?userId=$userId',headers: header );
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      print("_data $sum");
      for (var i in sum){
        var ggg = i['id'];
        print("ggg$ggg");
        _list.add(ggg);
      }
    }
    setState(() {
    });
    print("myrun $_list");
    return _list;
  }

  Future showList()async{
    print("stat :$stat");
    date2s = ('${_date.day}/${_date.month}/${_date.year}');
    s2date = new DateFormat('d/M/yyyy').parse(date2s);
    if(stat == "Admin"){
      print("admin");
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/show_all?userId=$userId',headers: header );
      if(data.statusCode == 200) {
        _isLoading = false;
        var _data = jsonDecode(data.body);
        print(_data);
        for (var i in _data) {
          Run run = Run(
            i["id"],
            i["nameAll"],
            i["distance"],
            i["type"],
            i["dateStart"],
            i["dateEnd"],
            i["imgAll"],
            i["userId"],
            i["createDate"],
            i["price"],
          );
            runs.add(run);
        }
      }else{
        _isLoading = false;
        setState(() {

        });
      }
    }else if(stat == 'User'){
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/load',headers: header );
      if(data.statusCode == 200) {
        _isLoading = false;
        var _data = jsonDecode(data.body);
        print(_data);
        var sum = _data['data'];
        for (var i in sum) {
          Run run = Run(
            i["id"],
            i["nameAll"],
            i["distance"],
            i["type"],
            i["dateStart"],
            i["dateEnd"],
            i["imgAll"],
            i["userId"],
            i["createDate"],
            i["price"],
          );
          var dd = i['dateStart'];
          var ddd = new DateFormat('d/M/yyyy').parse(dd);
          print("ddd $ddd");
          var ss = i['dateEnd'];
          var sss = new DateFormat('d/M/yyyy').parse(ss);
          print("sss $sss");
          if(s2date.isAfter(sss) ){
            runs.add(run);
          }else{

          }
        }
      }else{
        _isLoading = false;
        setState(() {

        });
      }
    }else{

    }
    print(runs);
    setState(() {

    });
    return runs;
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('หมดเวลาให้สมัครแล้ว'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );
  @override
  void initState() {
    _fileUtil.readFile().then((id){
      this.userId = id;
      print('id funrun ${userId}');
      getMyData();

      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการวิ่งที่ผ่านมาแล้ว'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.edit),
        //       onPressed: (){
        //         if(stat == "Admin"){
        //           // Navigator.push(context, MaterialPageRoute(builder: (context) => AddTournament()));
        //         }else{
        //           showCustomDialogNot(context);
        //         }
        //       }),
        // ],
      ),
      body: Container(
        child: _isLoading ? Center(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Loading(
              indicator: BallPulseIndicator(),
              size: 100.0,
              color: Colors.pink,
            ),
          ),
        ): ListView.builder(
            itemCount: runs.length,
            itemBuilder: (BuildContext context, int index){
              print('data');
              return Container(
                margin:EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () {
                          aaid = runs[index].id;
                          nameAll = runs[index].nameAll;
                          dis = runs[index].distance;
                          type = runs[index].type;
                          dates = runs[index].dateStart;
                          datee = runs[index].dateEnd;
                          img = runs[index].imgAll;
                          price = runs[index].price;
                          print(aaid);
                          print(nameAll);
                          print(dis);
                          print(type);
                          print(dates);
                          print(datee);
                          showCustomDialog(context);
                          // if(stat == "Admin"){
                          //   Navigator.push(context,
                          //       MaterialPageRoute(
                          //           builder: (BuildContext context) =>
                          //               EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
                          // }else{
                          //   check();
                          //   // Navigator.of(context).pop();
                          // }
                          // Navigator.push(context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             RegisterRun(aaid: aaid,)));
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: FadeInImage(
                                placeholder: AssetImage('assets/images/loading.gif'),
                                image: NetworkImage(
                                  '${Config.API_URL}/test_all/image?imgAll=${runs[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                                ),
                                width: 350,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(
                              title: Text("รายการ "+runs[index].nameAll +" ระยะทาง "+ runs[index].distance),
                              subtitle: Text(' จากวันที่ ' + runs[index].dateStart + ' ถึงวันที่ '
                                  + runs[index].dateEnd),

                            ),
                          ],
                        ),
                      ),

                    ),
                    _list.contains(runs[index].id) == true ? Container(
                      width: 70,
                      height: 30,
                      color: Colors.blue,
                      child: Text("สมัครแล้ว",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                    ):Padding(padding: EdgeInsets.zero,)
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
