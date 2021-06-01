import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/user/admindata.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:http/http.dart' as http;

class SuperAdminScreen extends StatefulWidget {
  @override
  _SuperAdminScreenState createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  var id;
  SystemInstance _systemInstance = SystemInstance();
  SystemInstance systemInstance = SystemInstance();
  List<TheUserData> userDataList = [];

  Future getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show_au?Au=Admin',headers: header );
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    for (var i in sum){
      TheUserData userData = TheUserData(
        i['userId'],
        i['userName'],
        i['passWord'],
        i['au'],
        i['name'],
        i['tel'],
        i['imgProfile'],
        i['autho'],
      );
      userDataList.add(userData);
    }
    return userDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text('รายชื่อผู้จัดงาน'),
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
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {

              print("null");
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 100.0,color: Colors.pink,
                  ),
                ),
              );
            } else {
              print("have");
              return ListView.builder(
                // itemBuilder: getItem ,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Card(
                          child: InkWell(
                            child: ListTile(
                              leading: Container(
                                height: 50.0,
                                width: 50.0,
                                child: FadeInImage(
                                  placeholder: AssetImage('assets/images/loading.gif'),
                                  image: NetworkImage(
                                    '${Config.API_URL}/user_profile/image?imgProfile=${snapshot.data[index].imgProfile}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(snapshot.data[index].name),
                              trailing: Icon(Icons.arrow_forward),
                              // subtitle: Text('จากรายการ ' +snapshot.data[index].nameAll + '\nเวลาที่ทำได้ ' + snapshot.data[index].time),

                            ),
                            onTap: (){
                              id = snapshot.data[index].userId;
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AdminDataScreen(userID: id)));
                            },
                          ),
                        ),
                      ],
                    );
                  });

            }
          },
        ),
      ),
    );
  }
}

class TheUserData{
  final int userId;
  final String userName;
  final String passWord;
  final String au;
  final String name;
  final String tel;
  final String imgProfile;
  final String autho;

  TheUserData(this.userId, this.userName, this.passWord, this.au, this.name, this.tel, this.imgProfile,this.autho);
}
