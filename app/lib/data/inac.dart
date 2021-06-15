import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InActiveScreen extends StatefulWidget {
  final int aaid;
  final String name;
  final String type;
  final String km;
  final String dateS;
  final String dateE;
  final String acces;
  final String img;
  final String price;
  final String active;
  final int userId;

  const InActiveScreen({Key key, this.aaid, this.name, this.type, this.km, this.dateS,this.img,this.userId, this.dateE, this.acces, this.price, this.active}) : super(key: key);

  @override
  _InActiveScreenState createState() => _InActiveScreenState();
}

class _InActiveScreenState extends State<InActiveScreen> {
  int rad;
  var name;
  var type;
  var dis;
  var dateS;
  var dateE;
  var access;
  var price;
  var active;
  var aid;
  var img;
  var userId;
  var rid;
  var size;
  var sta;
  var imgR;
  var userID;
  SystemInstance systemInstance = SystemInstance();
  SystemInstance _systemInstance = SystemInstance();


  Future getData()async{
    print("555");
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_run/load_check?id=$aid',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['data'];
    print(sum);
    for(var i in sum){
      rid = i['rid'];
      size = i['size'];
      sta = i['status'];
      imgR = i['imgR'];
      userID = i['userId'];
    }
  }

  void save(){
    var sta;
    if(rad == 0){
      sta = "yes";
      print(sta);
    }else if (rad == 1){
      sta = "no";
      print(sta);
    }
    Map params = Map();
    params['id'] = aid.toString();
    params['nameAll'] = name.toString();
    params["distance"] = dis.toString();
    params["type"] = type.toString();
    params["dateStart"] = dateS.toString();
    params["dateEnd"] = dateE.toString();
    params["userId"] = userId.toString();
    params["accessories"] = access.toString();
    params["active"] = sta.toString();
    params["price"] = price.toString();
    params["imgAll"] = img;
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/test_all/save', body: params,headers: header).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['status'];
      print(data);
      if (sta == "yes") {
        Navigator.pop(context);
        Navigator.pop(context);
        showCustomDialogPass(context);
      } else {
        // SystemInstance systemInstance = SystemInstance();
        // systemInstance.name = _name.text;
        print("hello");
        Navigator.pop(context);
        Navigator.pop(context);
        showCustomDialog(context);

      }
    });
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ปิดใช้งานชั่วคราว'),
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
        content: Text('เปิดให้ใช้งาน'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );
  void saveRun(){
    if(rid != null){
      print("saveR");
      print(active);
      var ac;
      if(rad == 0){
        ac = "yes";
        print(ac);
      }else if (rad == 1){
        ac = "no";
        print(ac);
      }
      Map params = Map();
      params['rid'] = rid.toString();
      params['id'] = aid.toString();
      params['userId'] = userID.toString();
      params['size'] = size.toString();
      params['status'] = sta.toString();
      params['imgSlip'] = imgR.toString();
      params['accessories'] = access.toString();
      params['active'] = ac.toString();
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      http.post('${Config.API_URL}/test_run/update_save', body: params,headers: header).then((res) {
        Map resMap = jsonDecode(res.body) as Map;
        var data = resMap['status'];
        print(data);
        print("888");
      });
    }else{
      print("sss");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    active = widget.active;
    aid = widget.aaid;
    print("active $active");
    if(active == "yes"){
      rad = 0;
    }else{
      rad = 1;
    }
    getData();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    name = widget.name;
    type = widget.type;
    dis = widget.km;
    dateE = widget.dateE;
    dateS = widget.dateS;
    access = widget.acces;
    price = widget.price;
    img = widget.img;
    userId = widget.userId;
    print(aid);
    print(img);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('สถานะการแสดงรายการ'),
          actions: [IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              save();
              saveRun();
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
                  leading: Text("ชื่อรายการ:",style: TextStyle(color: Colors.black),),
                  title: Text("$name", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("ประเภท:",style: TextStyle(color: Colors.black),),
                  title: Text("$type", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("ระยะทาง:",style: TextStyle(color: Colors.black),),
                  title: Text("$dis", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("วันที่เริ่มต้นการวิ่ง:",style: TextStyle(color: Colors.black),),
                  title: Text("$dateS", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("วันที่สิ้นสุดการวิ่ง:",style: TextStyle(color: Colors.black),),
                  title: Text("$dateE", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("ของที่ระลึก:",style: TextStyle(color: Colors.black),),
                  title: Text("$access", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Center(
              child: Card(
                child: ListTile(
                  leading: Text("ค่าสมัคร:",style: TextStyle(color: Colors.black),),
                  title: Text("$price", style: TextStyle(color: Colors.blueGrey),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text("สถานะการให้บริการ", style: TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [

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
                    child: Text("พร้อมใช้งาน",style: TextStyle(color: Colors.green),),
                  ),
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
                    child: Text("ยังไม่พร้อม",style: TextStyle(color: Colors.red),),
                  )

                ],
              ),
            ),
          ],
        )
    );
  }
}
