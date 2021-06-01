import 'dart:convert';
import 'dart:io';

import 'package:app/system/SystemInstance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/config/config.dart';

class AdminDataScreen extends StatefulWidget {
  final userID;

  const AdminDataScreen({Key key, this.userID}) : super(key: key);

  @override
  _AdminDataScreenState createState() => _AdminDataScreenState();
}

class _AdminDataScreenState extends State<AdminDataScreen> {
  SystemInstance _systemInstance = SystemInstance();
  SystemInstance systemInstance = SystemInstance();
  var user;
  var name = '';
  var tel = '';
  var img;
  var autho;
  int rad;
  var userName;
  var passWord;
  var au;
  File _image;

  Future data() async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$user',headers: header );
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for(var i in sum){
      userName = i['userName'];
      passWord = i['passWord'];
      au = i['au'];
      name = i['name'];
      tel = i['tel'];
      img = i['imgProfile'];
      autho = i['autho'];

    }
    if(autho == "not"){
      rad = 0;
    }else{
      rad = 1;
    }
    setState(() {
      userName = userName;
      passWord = passWord;
      au = au;
      name = name;
      tel = tel;
      img = img;
      autho = autho;
    });
  }
  void save(){
    var sta;
    if(rad == 0){
      sta = "not";
      print(sta.runtimeType);
    }else{
      sta = "allow";
      print(sta);
    }
    Map params = Map();
    params['userId'] = user.toString();
    params['userName'] = userName.toString();
    params['passWord'] = passWord.toString();
    params['name'] = name.toString();
    params['tel'] = tel.toString();
    params['au'] = au.toString();
    params['autho'] = sta.toString();
    params['imgProfile'] = img.toString();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/user_profile/update', body: params,headers: header).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['status'];
      print(data);
      if (data == 0) {
        print("hello");
        showCustomDialog(context);
      } else {
        // SystemInstance systemInstance = SystemInstance();
        // systemInstance.name = _name.text;
        Navigator.pop(context);
        showCustomDialogPass(context);
      }
    });
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('บันทึกไม่สำเร็จ'),
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );

  @override
  void initState() {
    // TODO: implement initState
    user = widget.userID;
    data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อมูลผู้จัดงาน'),
        actions: [IconButton(
          icon: Icon(Icons.check),
          onPressed: (){
            save();
          },
        )
        ],
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
      body: ListView(
        children: [
          img == null ? Padding(padding: EdgeInsets.zero,): Container(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child:Container(
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading.gif'),
                  image: NetworkImage(
                    '${Config.API_URL}/user_profile/image?imgProfile=$img',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                  ),
                  width: 250.0,
                  height: 250.0,
                ),
              ),
            ),
          ),
          Center(
            child: Card(
              child: ListTile(
                leading: Text("ชื่อ"),
                title: Text("$name", style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ),
          Center(
            child: Card(
              child: ListTile(
                leading: Text("เบอร์โทร"),
                title: Text("$tel", style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text("สถานะการให้สิทธิ์", style: TextStyle(color: Colors.black),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                  child: Radio(
                    value: 1,
                    groupValue: rad,
                    onChanged: (T){
                      print(T);
                      setState(() {
                        rad = T;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Text("อนุญาต",style: TextStyle(color: Colors.green),),
                ),
                Expanded(
                  child: Radio(
                    value: 0,
                    groupValue: rad,
                    onChanged: (T){
                      print(T);
                      setState(() {
                        rad = T;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Text("ไม่อนุญาต",style: TextStyle(color: Colors.red),),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
