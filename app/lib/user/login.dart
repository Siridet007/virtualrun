
import 'package:app/ui/profile.dart';
import 'package:app/ui/tournament.dart';
import 'package:app/user/regisadmin.dart';
import 'package:app/user/select.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/config/config.dart';
//import 'package:app/ui/nav.dart';
import 'dart:convert';
import 'package:app/util/file_util.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/main.dart';
import 'package:app/user/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  // final SaveFile save;
  // Login({Key key,@required this.save}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<Login> {
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool _hasUser = true;
  var userId;
  var userNameWrtie;
  var passWordWrite;
  var textRead;
  FileUtil _fileUtil = FileUtil();

  // Future<File> saveToFile() async{
  //   setState(() {
  //     textRead = userId.toString();
  //   });
  //   return widget.
  // }
  @override
  void initState(){

    super.initState();
    _fileUtil.readFile().then((value){
      setState(() {
        textRead = value;
        print("UserID: ${textRead}");
      });
    });
  }


  void logIn() async{
    print("hello");
    Map params = Map();
    params['username'] = userName.text;
    params['password'] = passWord.text;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.post('${Config.API_URL}/authorize', body: params).then((res) {
      print(http.post('${Config.API_URL}/authorize', body: params));
      //int loginPass = res.body.length;
      Map resMap = jsonDecode(res.body) as Map;
      print("res:$resMap");
      print("data${resMap["data"]}");


      if(resMap['data'] == 1){
        print("login success");
        Map resMap = jsonDecode(res.body) as Map;
        SystemInstance systemInstance = SystemInstance();
        systemInstance.userId = resMap["userId"];
        systemInstance.token = resMap["token"];
        systemInstance.userName = userName.text;
        systemInstance.passWord = passWord.text;
        userId = systemInstance.userId;
        _fileUtil.writeFile(systemInstance.userId);
        print("yes");
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => First()));
        showCustomDialogPass(context);
      }else if(resMap['data'] == 0){
        showCustomDialog(context);
        print("login faild");
      }
      sharedPreferences.setString("token", resMap['token']);

      // print(resMap);
      // int data = resMap['data'];
      // _id = resMap['getId'];
      // _data.user_id = _id;
      // print(_id);

      // _fileUtil.writeFile(_id);

      // if (data == 1) {
      //   _hasUser = true;
      //   print("yes");
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => First()));
      //   Widget okButton = FlatButton(
      //     child: Text("ปิด"),
      //     onPressed: () => Navigator.of(context).pop(),
      //   );
      //   AlertDialog alert = AlertDialog(
      //     content: Text("สวัสดี ${userName.text}"),
      //     actions: [
      //       okButton,
      //     ],
      //   );
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return alert;
      //     },
      //   );
      // } else {
      //   _hasUser = false;
      //   print("no");
      //
      //   Widget okButton = FlatButton(
      //     child: Text("ปิด"),
      //     onPressed: () => Navigator.of(context).pop(),
      //   );
      //   AlertDialog alert = AlertDialog(
      //     content: Text("ไม่มีชื่อผู้ใช้."),
      //     actions: [
      //       okButton,
      //     ],
      //   );
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return alert;
      //     },
      //   );
      // }
      setState(() {});
      print('body${res.body}');
    }).catchError((err) {
      print("err$err");
      Text('error');
    });
//
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ชื่อหรือรหัสผ่านไม่ถูกต้อง'),
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
        content: Text('ยินดีต้อนรับสู่แอปพลิเคชัน'),
        actions: [
          // FlatButton(
          //   onPressed: () => Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => First())),
          //   child: Text('ตกลง'),
          // )
        ],
      )
  );


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Virtual Run'),
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
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'ลงชื่อเข้าใช้',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20),

                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32
                  ),
                  child: Center(
                    child: Image.asset('assets/images/running.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 35, 10, 0),
                  child: TextField(
                    controller: userName,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan
                        ),
                      ),
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
                    controller: passWord,
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
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('เข้าสู่ระบบ'),
                      onPressed: () {

                        print(userName.text);
                        print(passWord.text);

                        logIn();
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('ยังไม่เป็นสมาชิก',style: TextStyle(color: Colors.blue),),
                        FlatButton(
                          textColor: Colors.lightBlue,
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                                fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectScreen()));
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}