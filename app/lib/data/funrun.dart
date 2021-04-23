import 'dart:convert';
import 'package:app/data/infodata.dart';
import 'package:app/data/editdata.dart';
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
import 'package:app/data/regis/registerrun.dart';
import 'package:app/data/add.dart';

class FunRun extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FunRun();
  }

}
class _FunRun extends State {

  List _uilist = List();
  FileUtil _fileUtil = FileUtil();
  SystemInstance _systemInstance = SystemInstance();
  var aid;
  var userId;
  var aaid;
  List<Run> runs = List();
  var stat = "";
  var nameAll;
  var dis;
  var type;
  var dates;
  var datee;
  var img;
  var price;
  bool _isLoading = true;

  Future _getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show?type=Fun Run',headers: header );
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
        i["userId"],
        i["createDate"],
        i["price"],
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

            child: Text('ดูรายชื่อผู้สมัคร',style: TextStyle(color: Colors.blue),),
          ),
          FlatButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              checkList(),
              //
            },
            child: Text("แก้ไข",style: TextStyle(color: Colors.red),),
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
    // print(_data);
    var sum = _data['data'];
    for(var i in sum){
      // print(i);
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
    setState(() {
      stat = stat;
    });
    print(stat);
    showList();
    return stat;
  }

  Future showList()async{
    print("stat :$stat");
    if(stat == "Admin"){
      print("admin");
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/test_all/show_list?type=Fun Run&userId=$userId',headers: header );
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
      var data = await http.post('${Config.API_URL}/test_all/show?type=Fun Run',headers: header );
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


  Widget getItem(BuildContext context, int i) {
    return _uilist[i];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fun Run'),
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
                child: Card(
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
                      print(price);
                      if(stat == "Admin"){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
                      }else{
                        // showCustomDialogRegis(context);
                        // Navigator.of(context).pop();
                        check();
                        //
                      }
                      //
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
              );
            }
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,MaterialPageRoute(builder: (context) => AddTournament()));
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),

    );
  }
}

class Run{
  final int id;
  final String nameAll;
  final String distance;
  final String type;
  final String dateStart;
  final String dateEnd;
  final String imgAll;
  final int userId;
  final String createDate;
  final String price;

  Run(this.id, this.nameAll, this.distance, this.type, this.dateStart, this.dateEnd, this.imgAll, this.userId, this.createDate, this.price);


}
