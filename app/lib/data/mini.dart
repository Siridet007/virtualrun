import 'dart:convert';
import 'package:app/system/SystemInstance.dart';
import 'package:app/tester/testall.dart';
import 'package:app/ui/profile.dart';
import 'package:app/util/file_util.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import '../config/config.dart';
import 'editdata.dart';
import 'funrun.dart';
import 'package:app/data/regis/registerrun.dart';

import 'infodata.dart';

class Mini extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Mini();
  }

}
class _Mini extends State{
  SystemInstance _systemInstance = SystemInstance();
  List<Run> runs = [];
  List _list = List();
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
  final _date = new DateTime.now();
  var date2s;
  var s2date;
  // Future _getData()async{
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   var data = await http.post('${Config.API_URL}/all_run/test?type=Mini',headers: header );
  //   var _data = jsonDecode(data.body);
  //   print(_data);
  //   for(var i in _data){
  //     Run run = Run(
  //         i["aid"],
  //         i["distance"],
  //         i["time"],
  //         i["type"]
  //     );
  //     runs.add(run);
  //   }
  //   print(runs);
  //   return runs;
  // }

  // Future _getTheData()async{
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   var data = await http.post('${Config.API_URL}/test_all/show?type=Mini',headers: header );
  //   var _data = jsonDecode(data.body);
  //   print(_data);
  //   for(var i in _data){
  //     Run run = Run(
  //       i["id"],
  //       i["nameAll"],
  //       i["distance"],
  //       i["type"],
  //       i["dateStart"],
  //       i["dateEnd"],
  //       i["imgAll"],
  //       i["userId"],
  //       i["createDate"],
  //       i["price"],
  //     );
  //     _list.add(run);
  //   }
  //   print(_list);
  //   return _list;
  // }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('สมัครสำเร็จ'),
        actions: [
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
            },
            child: Text('ปิด'),
          )
        ],
      )
  );
  Future showCustomDialogFailed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ท่านได้สมัครรายการนี้ไปแล้ว'),
        actions: [
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
            },
            child: Text('ปิด'),
          )
        ],
      )
  );
  Future showCustomDialogEditFailed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ไม่สามารถแก้ไขได้'),
        actions: [
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
            },
            child: Text('ปิด'),
          )
        ],
      )
  );

  Future showCustomDialogEdit(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('เลือกรายการที่ต้อง'),
        actions: [
          FlatButton(
            onPressed: () =>{
              Navigator.of(context).pop(),
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          InfoDataScreen(aid: aaid,))),
            },

            child: Text('ดูรายชื่อผู้สมัคร',style: TextStyle(color: Colors.red),),
          ),
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              checkList(),
              //
            },
            child: Text("แก้ไข",style: TextStyle(color: Colors.blue),),
          ),
        ],
      )
  );

  Future checkList()async{
    print(aaid);
    var user;
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show_id?id=$aaid',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    for(var i in _data){
      user = i['userId'];
    }
    print(user);
    print(userId);
    if(userId == user){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
    }else{
      showCustomDialogEditFailed(context);
    }
  }

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
  Future showList()async{
    print("stat :$stat");
    date2s = ('${_date.day}/${_date.month}/${_date.year}');
    s2date = new DateFormat('d/M/yyyy').parse(date2s);
    if(stat == "Admin"){
      print("admin");
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/show_list?type=Mini&userId=$userId',headers: header );
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
      var data = await http.post('${Config.API_URL}/test_all/show?type=Mini',headers: header );
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
          var dd = i['dateStart'];
          var ddd = new DateFormat('d/M/yyyy').parse(dd);
          print("ddd $ddd");
          var ss = i['dateEnd'];
          var sss = new DateFormat('d/M/yyyy').parse(ss);
          print("sss $sss");
          if(s2date.isAtSameMomentAs(ddd) && s2date.isBefore(ddd) || s2date.isAfter(sss) ){

          }else{
            runs.add(run);
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

  Future check()async{
    print(userId);
    print(aaid);
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_run/check?id=$aaid&userId=$userId',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['status'];
    if (sum == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  RegisterRun(aaid: aaid,name: nameAll,dis: dis,dates: dates,datee: datee,price: price,)));
    }else{
      showCustomDialogFailed(context);
    }
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

  @override
  void initState() {
    _fileUtil.readFile().then((id){
      this.userId = id;
      print('id funrun ${userId}');
      getMyData();
      showList();
      setState(() {

      });
    });
    super.initState();
  }

  // @override
  // void initstate(){
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   var data = http.post('${Config.API_URL}/all_run/test?type=Mini',headers: header );
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mini Marathon'),
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
                        if(stat == "Admin"){
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
                        }else{
                          check();
                          // Navigator.of(context).pop();
                        }
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
