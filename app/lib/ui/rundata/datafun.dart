import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/rundata/infodata/datauser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import '../profile.dart';
import 'datarunner.dart';

class DataFun extends StatefulWidget {
  @override
  _DataFunState createState() => _DataFunState();
}

class _DataFunState extends State<DataFun> {
  SystemInstance _systemInstance = SystemInstance();
  List<DataRunner> _dataFun = [];
  List<TotalData> _total = [];
  List<TotalMyData> _list = [];
  List<MyData> _listData = [];
  List<MyGetData> myList = [];
  var getsum;
  var getget;
  var stat;
  var userId;

  List dataList = List();
  List listData = List();

  List kmList = List();
  List timeList = List();
  List typeList = List();
  List userIdList = List();
  List nameList = List();
  List imgList = List();
  List<String> theList = List();
  bool _isLoading = true;

  Future get() async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/ranking/show_type?type=Fun Run',
        headers: header);
    if (data.statusCode == 200) {
      _isLoading = false;
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      print("length: ${sum.length}");
      print("sum: $sum");
      for (var i in sum) {
        print(i);
        MyGetData myGetData = MyGetData(i['rankingId'], i['userId'], i['name'],
            i['nameAll'], i['km'], i['time'], i['type'], i['imgRanking']);
        print(myGetData);
        myList.add(myGetData);
        print(myList);
      }
      // var len = (sum.length).toString();
      // print(len);
      // int le = int.parse(len);
      setState(() {});
      print(myList);
      return myList;
    } else {
      _isLoading = false;
      setState(() {});
    }
  }

  // Future getMyDataFun()async{
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   var data = await http.post('${Config.API_URL}/success_data/show_id?type=Fun Run',headers: header);
  //   var _data = jsonDecode(data.body);
  //   var sum = _data['data'];
  //   var get = _data['getData'];
  //   var allMap = {};
  //   // var kkk = sum.add(get);
  //   // print(sum.add(get));
  //   // sum.add(get);
  //   print("sum: ${sum}");
  //   print("get: $get");
  //   // for(var i in sum){
  //   //   print('i${i}');
  //   //   TotalData totalData = TotalData(
  //   //       i['successId'],
  //   //       i['userId'],
  //   //       i['id'],
  //   //       i['km'],
  //   //       i['time'],
  //   //       i['type']
  //   //   );
  //   //   _total.add(totalData);
  //   // }
  //   // print("total$_total");
  //   for(var a in get){
  //     print('a${a}');
  //     // MyData myData = MyData(
  //     //     a['userMyId'],
  //     //     a['userName'],
  //     //     a['passWord'],
  //     //     a['au'],
  //     //     a['name'],
  //     //     a['tel'],
  //     //     a['imgProfile']
  //     // );
  //     sum.add(a);
  //     // _listData.add(myData);
  //   }
  //   print("sum$sum");
  //   for(var h in sum){
  //     print(h);
  //     TotalMyData totalMyData = TotalMyData(
  //           h['successId'],
  //           h['userId'],
  //           h['id'],
  //           h['km'],
  //           h['time'],
  //           h['type'],
  //           h['userId'],
  //           h['userName'],
  //           h['passWord'],
  //           h['au'],
  //           h['name'],
  //           h['tel'],
  //           h['imgProfile']
  //       );
  //     _list.add(totalMyData);
  //     dataList.add(h['successId']);
  //     dataList.add(h['userId']);
  //     dataList.add(h['id']);
  //     dataList.add(h['km']);
  //     dataList.add(h['time']);
  //     dataList.add(h['type']);
  //     dataList.add(h['userId']);
  //     dataList.add(h['userName']);
  //     dataList.add(h['passWord']);
  //     dataList.add(h['au']);
  //     dataList.add(h['name']);
  //     dataList.add(h['tel']);
  //     dataList.add(h['imgProfile']);
  //
  //   }
  //   print(_list);
  //   print("list:$dataList");
  //   // kmList.addAll(_listData);
  //   // print("kmmm$kmList");
  //   // for(var c in kmList){
  //   //   print("c$c");
  //   // }
  //   // // TotalMyData totalMyData = TotalMyData(
  //   // //     allMap['tid'],
  //   // //     allMap['userId'],
  //   // //     allMap['id'],
  //   // //     allMap['km'],
  //   // //     allMap['time'],
  //   // //     allMap['type'],
  //   // //     allMap['userMyId'],
  //   // //     allMap['userName'],
  //   // //     allMap['passWord'],
  //   // //     allMap['au'],
  //   // //     allMap['name'],
  //   // //     allMap['tel'],
  //   // //     allMap['imgProfile']
  //   // // );
  //   // print("aaa");
  //   // // dataList.add(_total);
  //   // // dataList.add(_listData);
  //   // // _list.add(totalMyData);
  //   // print("my$dataList");
  //   // print(_list);
  //   // print(_total);
  //   // print(_listData);
  //   return _list;
  // }

  Future getData() async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/user_profile/show?userId=$userId',
        headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['data'];
    for (var i in sum) {
      print(i);
      ProfileData(i['userId'], i['userName'], i['passWord'], i['au'], i['name'],
          i['tel'], i['imgProfile']);
      stat = i['au'];
    }
    print(stat);
    return stat;
  }

  // Future<Album> fetchAlbum() async {
  //   final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Album.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // get();
    SystemInstance systemInstance = SystemInstance();
    userId = systemInstance.userId;
    getData();
    get();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: _isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Loading(
                      indicator: BallPulseIndicator(),
                      size: 100.0,
                      color: Colors.pink,
                    ),
                  ),
                )
              : ListView.builder(
                  // itemBuilder: getItem ,
                  itemCount: myList.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("hehhe${myList[index].imgRanking}");
                    return Column(
                      children: [
                        Card(
                          child: InkWell(
                            child: ListTile(
                              leading: Container(
                                height: 50.0,
                                width: 50.0,
                                child: myList[index].imgRanking == null
                                    ? Image.asset(
                                        'assets/images/nonprofile.png',
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/loading.gif'),
                                        image: NetworkImage(
                                          '${Config.API_URL}/user_profile/image?imgProfile=${myList[index].imgRanking}',
                                          headers: {
                                            "Authorization":
                                                "Bearer ${_systemInstance.token}"
                                          },
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(myList[index].name),
                              subtitle: Text('จากรายการ ' +
                                  myList[index].nameAll +
                                  '\nเวลาที่ทำได้ ' +
                                  myList[index].time),
                              onTap: () {
                                if (stat == 'Admin') {
                                  print("yes");
                                  var user = myList[index].userId;
                                  print("user$user");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DataUserScreen(
                                                userId: user,
                                              )));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
    );
  }
}

class TotalData {
  final int successId;
  final int userId;
  final int id;
  final String km;
  final String time;
  final String type;

  TotalData(
      this.successId, this.userId, this.id, this.km, this.time, this.type);
}

class TotalMyData {
  final int tid;
  final int userId;
  final int id;
  final String km;
  final String time;
  final String type;
  final int userMyId;
  final String userName;
  final String passWord;
  final String au;
  final String name;
  final String tel;
  final String imgProfile;

  TotalMyData(
      this.tid,
      this.userId,
      this.id,
      this.km,
      this.time,
      this.type,
      this.userMyId,
      this.userName,
      this.passWord,
      this.au,
      this.name,
      this.tel,
      this.imgProfile);
}

class MyData {
  final int userMyId;
  final String userName;
  final String passWord;
  final String au;
  final String name;
  final String tel;
  final String imgProfile;

  MyData(this.userMyId, this.userName, this.passWord, this.au, this.name,
      this.tel, this.imgProfile);
}

class MyGetData {
  final int rankingId;
  final int userId;
  final String name;
  final String nameAll;
  final String km;
  final String time;
  final String type;
  final String imgRanking;

  MyGetData(this.rankingId, this.userId, this.name, this.nameAll, this.km,
      this.time, this.type, this.imgRanking);
}
