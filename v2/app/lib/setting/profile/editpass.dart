import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class EditPassWordScreen extends StatefulWidget {
  @override
  _EditPassWordScreenState createState() => _EditPassWordScreenState();
}

class _EditPassWordScreenState extends State<EditPassWordScreen> {
  var userId;
  var userName;
  TextEditingController newPassWord = TextEditingController();
  TextEditingController passWord = TextEditingController();
  var oldPass;
  var name;
  var tel;
  var au;
  SystemInstance systemInstance = SystemInstance();
  SystemInstance _systemInstance = SystemInstance();

  Future getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for (var i in sum){
      userName = i['userName'];
      oldPass = i['passWord'];
      name = i['name'];
      tel = i['tel'];
      au = i['au'];
    }
  }

  void onClick(){
    print("ตรง");
    Map params = Map();
    params['userId'] = userId;
    params['userName'] = userName.toString();
    params['passWord'] = newPassWord.text;
    params['name'] = name.toString();
    params['tel'] = tel.toString();
    params['au'] = au.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    userId = systemInstance.userId;
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("เปลี่ยนรหัสผ่าน",),
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: passWord,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'รหัสผ่านเดิม',
                ),
              ),
            ),Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: newPassWord,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'รหัสผ่านใหม่',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('เปลี่ยนรหัสผ่าน'),
                onPressed: () {
                  if(passWord == oldPass){
                    onClick();
                  }else{
                    CoolAlert.show(context: context, type: CoolAlertType.warning, text: 'กรุณากรอกรหัสผ่านเดิมให้ถูกต้อง');
                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
