import 'dart:convert';
import 'dart:io';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class InfoUserScreen extends StatefulWidget {
  final int userID;
  final int aid;

  const InfoUserScreen({Key key, this.userID,this.aid}) : super(key: key);
  @override
  _InfoUserScreenState createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> {
  var myUserId;
  SystemInstance _systemInstance = SystemInstance();
  SystemInstance systemInstance = SystemInstance();
  List<MyInfo> _list = List();
  var time = "";
  var status;
  var img;
  File _image;
  final picker = ImagePicker();
  var pickedFile;
  var aid;
  var size = "";
  int rad;
  var rid;
  var myTime;
  var access;
  var active;



  Future getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var res = await http.post('${Config.API_URL}/test_run/load?id=$aid&userId=$myUserId',headers: header );
    var data = utf8.decode(res.bodyBytes);
    var _data = jsonDecode(data);
    var sum = _data['data'];
    print(sum);
    for(var i in sum){
      myTime = i['createDate'];
      img = i['imgSlip'];
      status = i['status'];
      size = i['size'];
      rid = i['rid'];
      access = i['accessories'];
      active = i['active'];
    }
    var myDate = myTime.toString();
    print("myDate $myDate");
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(myDate);
    print("date $parseDate");
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);
    var ss = status.toString();
    setState(() {
      time = outputDate;
      img = img;
      rad = int.parse(ss);
      size = size;
      access = access;
    });
    print(time);
    print(img);
    print(rad);
    print(access);
  }
  Future getImage() async{
    pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 200.0,maxWidth: 200.0,imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
  void save(){
    var sta;
    if(rad == 0){
      sta = "0";
      print(sta);
    }else{
      sta = "1";
      print(sta);
    }
    Map params = Map();
    params['rid'] = rid.toString();
    params['id'] = aid.toString();
    params['userId'] = myUserId.toString();
    params['size'] = size.toString();
    params['status'] = sta.toString();
    params['imgSlip'] = img.toString();
    params['accessories'] = access.toString();
    params['active'] = active.toString();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/test_run/update_save', body: params,headers: header).then((res) {
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
    aid = widget.aid;
    myUserId = widget.userID;

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('ตรวจสอบการสมัคร'),
          actions: [IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              save();
            },
          )],
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
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("เวลาที่สมัคร:"),
                  title: Text("$time", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            if(access == "shirt")...[
              Center(
                child: Card(
                  child: ListTile(
                    leading: Text('ขนาดเสื้อ:'),
                    title: Text("$size", style: TextStyle(color: Colors.blueGrey),),
                  ),
                ),
              ),
            ]else ...[
            ],


            img == null ? Padding(padding: EdgeInsets.zero,): Container(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child:Container(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/loading.gif'),
                    image: NetworkImage(
                      '${Config.API_URL}/test_run/image?imgSlip=$img',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                    ),
                    width: 250.0,
                    height: 250.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text("สถานะการจ่ายเงิน", style: TextStyle(color: Colors.black),),
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
                    child: Text("จ่ายแล้ว",style: TextStyle(color: Colors.green),),
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
                    child: Text("ยังไม่จ่าย",style: TextStyle(color: Colors.red),),
                  )

                ],
              ),
            ),
          ],
        )
    );
  }
}
class MyInfo{
  final int rid;
  final int userId;
  final int id;
  final String size;
  final String createDate;
  final String status;
  final String imgSlip;

  MyInfo(this.rid, this.userId, this.id, this.size, this.createDate, this.status, this.imgSlip);

}
