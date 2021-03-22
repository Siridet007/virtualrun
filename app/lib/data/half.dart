import 'dart:convert';
import 'package:app/system/SystemInstance.dart';
import 'package:app/tester/testall.dart';
import 'package:app/ui/profile.dart';
import 'package:app/util/file_util.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import '../config/config.dart';
import 'editdata.dart';
import 'funrun.dart';
import 'package:app/data/regis/registerrun.dart';

class Half extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Half();
  }

}
class _Half extends State{
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

  Future _getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show?type=Half',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    for(var i in _data){
      Run run = Run(
        i["id"],
        i["nameAll"],
        i["distance"],
        i["type"],
        i["dateStart"],
        i["dateEnd"],
        i["imgAll"],
      );
      runs.add(run);
    }
    print(runs);
    return runs;
  }
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
  Future showCustomDialogNot(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('สำหรับระบบเท่านั้น'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );

  Future showCustomDialogEdit(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ต้องการแก้ไขรายการนี้หรือไม่'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),

            child: Text('ไม่',style: TextStyle(color: Colors.red),),
          ),
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              checkList(),
              //
            },
            child: Text("ใช่",style: TextStyle(color: Colors.blue),),
          ),
        ],
      )
  );
  Future showCustomDialogRegis(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ต้องการสมัครรายการนี้หรือไม่'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),

            child: Text('ไม่',style: TextStyle(color: Colors.red),),
          ),
          FlatButton(
            onPressed: () => {
              saveData(),
              Navigator.of(context).pop(),
            },
            child: Text("ใช่",style: TextStyle(color: Colors.blue),),
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
                  EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,)));
    }else{
      showCustomDialogEditFailed(context);
    }
  }
  void saveData(){
    print(aaid);
    Map params = Map();
    params['id'] = aaid.toString();
    params['userId'] = userId.toString();
    print(params);
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/test_run/save_run',headers: header, body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      print("resMap$resMap");
      var data = resMap['status'];
      print(data);
      if(data == 1){
        print("yes");
        showCustomDialog(context);
      }else{
        print('no');
        showCustomDialogFailed(context);
      }
    });
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
    return stat;
  }
  Future showList()async{
    print("stat :$stat");
    if(stat == "Admin"){
      print("admin");
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/show_list?type=Half&userId=$userId',headers: header );
      var _data = jsonDecode(data.body);
      print(_data);
      for(var i in _data){
        Run run = Run(
          i["id"],
          i["nameAll"],
          i["distance"],
          i["type"],
          i["dateStart"],
          i["dateEnd"],
          i["imgAll"],
        );
        runs.add(run);
      }
    }else if(stat == 'User'){
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/show?type=Half',headers: header );
      var _data = jsonDecode(data.body);
      print(_data);
      for(var i in _data){
        Run run = Run(
          i["id"],
          i["nameAll"],
          i["distance"],
          i["type"],
          i["dateStart"],
          i["dateEnd"],
          i["imgAll"],
        );
        runs.add(run);
      }
    }else{

    }
    print(runs);
    setState(() {

    });
    return runs;
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Half Marathon'),
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
        child: runs.isEmpty ? Center(
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
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: InkWell(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          height: 50.0,
                          width: 50.0,
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/loading.gif'),
                            image: NetworkImage(
                              '${Config.API_URL}/test_all/image?imgAll=${runs[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text("รายการ "+runs[index].nameAll +" ระยะทาง "+ runs[index].distance),
                        subtitle: Text(' จากวันที่ ' + runs[index].dateStart + ' ถึงวันที่ '
                            + runs[index].dateEnd),
                        onTap: () {
                          aaid = runs[index].id;
                          nameAll = runs[index].nameAll;
                          dis = runs[index].distance;
                          type = runs[index].type;
                          dates = runs[index].dateStart;
                          datee = runs[index].dateEnd;
                          img = runs[index].imgAll;
                          print(aaid);
                          print(nameAll);
                          print(dis);
                          print(type);
                          print(dates);
                          print(datee);
                          if(stat == "Admin"){
                            checkList();
                          }else{
                            showCustomDialogRegis(context);
                            // Navigator.of(context).pop();
                          }
                          // Navigator.push(context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             RegisterRun(aaid: aaid,)));
                        },
                      ),
                    ],
                  ),
                ),

              );
            }
        ),
      ),
    );
  }

}