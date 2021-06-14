import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class RegisterSuperScreen extends StatefulWidget {
  const RegisterSuperScreen({Key key}) : super(key: key);

  @override
  _RegisterSuperScreenState createState() => _RegisterSuperScreenState();
}

class _RegisterSuperScreenState extends State<RegisterSuperScreen> {

  TextEditingController _userName = TextEditingController();
  TextEditingController _passWord = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _tel = TextEditingController();
  String dropdown = 'User';
  String au = 'super';
  String allow = "allow";

  void onRegister() {
    Map params = Map();
    params['userName'] = _userName.text;
    params['passWord'] = _passWord.text;
    params['name'] = _name.text;
    params['tel'] = _tel.text;
    params['au'] = au.toString();
    params['autho'] = allow.toString();
    //params['confirmPassWord'] = _conFirmPassWord.text;

    http.post('${Config.API_URL}/user_profile/save', body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      int data = resMap['data'];
      //id = resMap['getId'];
      if (data == 0) {
        print("hello");
        showCustomDialog(context);
      } else {
        // SystemInstance systemInstance = SystemInstance();
        // systemInstance.name = _name.text;
        showCustomDialogPass(context);
      }
    });

    setState(() {});
  }

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('มีชื่อผู้ใช้หรือรหัสผ่านนี้อยู่แล้ว'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );
  Future showCustomDialogPass(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('บันทึกสำเร็จ'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login())),
            child: Text('ปิด'),
          )
        ],
      )
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('สมัครสมาชิก'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.cyan],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'กรอกข้อมูลให้ครบถ้วน',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _userName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อผู้ใช้',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  obscureText: true,
                  controller: _passWord,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รหัสผ่าน',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อโปรไฟล์',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  controller: _tel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'เบอร์โทรศัพท์',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('ลงทะเบียน'),
                  onPressed: () {
                    print(_userName.text);
                    print(_passWord.text);
                    // print(_name.text);
                    onRegister();
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
