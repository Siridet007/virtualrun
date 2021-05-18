import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/ranking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'infodata/datauser.dart';
import '../profile.dart';
import 'datafun.dart';
import 'datarunner.dart';
class DataHalf extends StatefulWidget {
  @override
  _DataHalfState createState() => _DataHalfState();
}

class _DataHalfState extends State<DataHalf> {
  SystemInstance _systemInstance = SystemInstance();
  List<DataRunner> _dataHalf = [];
  List<TotalMyData> _list = [];

  List<MyGetData> myList = [];
  var stat;
  var userId;
  bool _isLoading = true;

  Future get()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/ranking/show_type?type=Half',headers: header);
    if(data.statusCode == 200) {
      _isLoading = false;
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      print("length: ${sum.length}");
      print("sum: $sum");
      for (var i in sum) {
        print(i);
        MyGetData myGetData = MyGetData(
            i['rankingId'],
            i['userId'],
            i['name'],
            i['nameAll'],
            i['km'],
            i['time'],
            i['type'],
            i['imgRanking']
        );
        print(myGetData);
        myList.add(myGetData);
        print(myList);
      }
      // var len = (sum.length).toString();
      // print(len);
      // int le = int.parse(len);
      setState(() {

      });
      print(myList);
      return myList;
    }else{
      _isLoading = false;
      setState(() {

      });
    }
  }
  Future getData()async{
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
    return stat;
  }

  @override
  void initState() {
    // TODO: implement initState
    // get();
    SystemInstance systemInstance = SystemInstance();
    userId = systemInstance.userId;
    getData();
    get();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: _isLoading ? Center(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Loading(
                indicator: BallPulseIndicator(),
                size: 100.0,color: Colors.pink,
              ),
            ),
          ):
          ListView.builder(
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
                            child: (myList[index].imgRanking) == null ? Image.asset(
                              'assets/images/nonprofile.png',
                              height: 150,
                              fit:BoxFit.cover,
                            ):FadeInImage(
                              placeholder: AssetImage('assets/images/loading.gif'),
                              image: NetworkImage(
                                '${Config.API_URL}/user_profile/image?imgProfile=${myList[index].imgRanking}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(myList[index].name),
                          subtitle: Text('จากรายการ ' +myList[index].nameAll + '\nเวลาที่ทำได้ ' + myList[index].time),
                          onTap: (){
                            if(stat == 'Admin'){
                              print("yes");
                              var user = myList[index].userId;
                              print("user$user");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DataUserScreen(userId: user,)));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
      ),
    );
  }
}
