import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTournament extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddTournament();
  }
}

class _AddTournament extends State<AddTournament> {
  final format = DateFormat.yMd();
  DateTime _date = new DateTime.now();
  DateTime _dateTime = new DateTime.now();
  var myDate = 'ยังไม่ได้เลือก';
  var myEndDate = 'ยังไม่ได้เลือก';
  TextEditingController nameAll = TextEditingController();
  TextEditingController km = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController accessories = TextEditingController();
  String dropdown = '';
  SystemInstance _systemInstance = SystemInstance();
  File _image;
  File _f;
  final picker = ImagePicker();
  var pickedFile;
  var userId;
  SystemInstance systemInstance = SystemInstance();
  String kmDrop = '';
  TextEditingController price = TextEditingController();
  Dialog dialog = new Dialog();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  int rad;
  TextEditingController access = TextEditingController();
  // defaultImage() async {
  //   _f = await getImageFileFromAssets('NoImage.png');
  // }
  //
  // Future<File> getImageFileFromAssets(String path) async {
  //   final byteData = await rootBundle.load('images/$path');
  //   final file = File('${(await getTemporaryDirectory()).path}/$path');
  //   await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   return file;
  // }

  Future getImage() async {
    pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('บันทึกสำเร็จ'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              )
            ],
          ));
  Future showCustomDialogLoad(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text('รอสักครู่'),
        );
      });

  void add() {
    var aa;
    var aaa = 'yes';
    if(accessories == "เสื้อ"){
      print("$accessories");
    }
    if(rad == 0){
      aa = "เสื้อ";
    }else if(rad == 1){
      aa = "ไม่มี";
    }else if(rad == 2){
      aa = access.text;
    }else{

    }
    print(userId);
    Dio dio = Dio();
    Map<String, dynamic> params = Map();
    params['nameAll'] = nameAll.text;
    params["distance"] = kmDrop;
    params["type"] = dropdown;
    params["dateStart"] = myDate;
    params["dateEnd"] = myEndDate;
    params["userId"] = userId.toString();
    params["accessories"] = aa.toString();
    params["active"] = aaa.toString();
    params["price"] = price.text;
    params['fileImg'] = MultipartFile.fromBytes(_image.readAsBytesSync(),
        filename: "filename.png");
    FormData formData = FormData.fromMap(params);
    // Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}";
    print(
        "adsad${dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}"}");
    dio.post('${Config.API_URL}/test_all/update', data: formData).then((res) {
      Map resMap = jsonDecode(res.toString()) as Map;
      // SystemInstance systemInstance = SystemInstance();
      // systemInstance.aid = resMap["aid"];
      // _fileUtil.writeFile(systemInstance.aid);
      var data = resMap['status'];
      if (data == 1) {
        Navigator.pop(context);
        showCustomDialog(context);
        setState(() {});
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'ทำรายการไม่สำเร็จ');
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picker != null) {
      print('Date:${_date.toString()}');
      setState(() {
        _date = picker;
        myDate = ("${_date.day}/${_date.month}/${_date.year}");
      });
    } else {
      print("null");
      DateTime defDate = new DateTime.now();
      myDate = ("${defDate.day}/${defDate.month}/${defDate.year}");
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateTime = picked;
        myEndDate = ("${_dateTime.day}/${_dateTime.month}/${_dateTime.year}");
      });
    } else {
      DateTime defEndDate = new DateTime.now();
      myEndDate = ("${defEndDate.day}/${defEndDate.month}/${defEndDate.year}");
    }
  }


  @override
  void initState(){
    // TODO: implement initState
    // defaultImage();
    userId = systemInstance.userId;

    DateTime defDate = new DateTime.now();
    myDate = ("${defDate.day}/${defDate.month}/${defDate.year}");
    DateTime defEndDate = new DateTime.now();
    myEndDate = ("${defEndDate.day}/${defEndDate.month}/${defEndDate.year}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(myDate);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('เพิ่มรายการวิ่ง'),
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
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameAll,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ชื่อรายการวิ่ง',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: DropDownField(
                    controller: typeRunSelect,
                    hintText: "เลือกรายการที่เปิดรับสมัคร",
                    enabled: true,
                    itemsVisibleInDropdown: 5,
                    items: typeRun,
                    textStyle: TextStyle(color: Colors.black),
                    onValueChanged: (value) {
                      setState(() {
                        dropdown = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    children: [
                      if (dropdown == 'Fun Run') ...[
                        funWidget(),
                      ] else if (dropdown == 'Mini') ...[
                        miWidget(),
                      ] else if (dropdown == 'Half') ...[
                        halfWidget(),
                      ] else if (dropdown == 'Full') ...[
                        fullWidget(),
                      ] else
                        ...[]
                    ],
                  ),
                ),
                SizedBox(height: 24),
                //
                // Container(
                //   padding: EdgeInsets.all(10),
                //   child: TextField(
                //     controller: time,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'เวลา',
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'เลือกวันที่เริ่มต้น',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.date_range),
                            iconSize: 50,
                            color: Colors.green,
                            onPressed: () => _selectDate(context),
                          ),
                          Text(
                            "${myDate}",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'เลือกวันสิ้นสุด',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.date_range),
                            iconSize: 50,
                            color: Colors.red,
                            onPressed: () => _selectEndDate(context),
                          ),
                          Text(
                            "${myEndDate}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text("ของที่ระลึก", style: TextStyle(color: Colors.black),),
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
                        child: Text("เสื้อ",style: TextStyle(color: Colors.black),),
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
                        child: Text("ไม่มี",style: TextStyle(color: Colors.black),),
                      ),
                      Expanded(
                        child: Radio(
                          value: 2,
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
                        child: Text("อื่นๆ",style: TextStyle(color: Colors.black),),
                      ),

                    ],
                  ),
                ),
                rad == 2 ? Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: access,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'โปรดระบุ',
                        // hintText: '*0 = ไม่มีค่าสมัคร'
                    ),
                  ),
                ):Padding(padding: EdgeInsets.zero),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: price,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ราคาค่าสมัคร',
                        hintText: '*0 = ไม่มีค่าสมัคร'),
                  ),
                ),

                // SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: _image == null
                        ? Container(
                            child: Center(
                              child: Text('เลือกรูปภาพ'),
                            ),
                            color: Colors.grey[200],
                            width: 250.0,
                            height: 250.0,
                          )
                        : Image.file(_image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                  child: Container(
                    child: RaisedButton.icon(
                      label: Text('เพิ่มรูปภาพ'),
                      icon: Icon(Icons.add_a_photo),
                      onPressed: getImage,
                    ),
                  ),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('เพิ่ม'),
                      onPressed: () async {
                        if (nameAll.text.isNotEmpty &&
                            dropdown != '' &&
                            kmDrop != '') {
                          print("nameAll $nameAll");
                          print("dropdown $dropdown");
                          print("kmDrop $kmDrop");
                          showCustomDialogLoad(context);
                          add();
                        } else {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              text: 'กรุณากรอกข้อมูลให้ครบถ้วน');
                        }
                      },
                    )),
              ],
            )));
  }

  Align funWidget() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: DropDownField(
            controller: disFun,
            hintText: "เลือกระยะทาง",
            enabled: true,
            itemsVisibleInDropdown: 3,
            items: fun,
            textStyle: TextStyle(color: Colors.black),
            onValueChanged: (value) {
              setState(() {
                kmDrop = value;
              });
            }),
      ),
    );
  }

  Align miWidget() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: DropDownField(
            controller: disMi,
            hintText: "เลือกระยะทาง",
            enabled: true,
            itemsVisibleInDropdown: 3,
            items: mi,
            textStyle: TextStyle(color: Colors.black),
            onValueChanged: (value) {
              setState(() {
                kmDrop = value;
              });
            }),
      ),
    );
  }

  Align halfWidget() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: DropDownField(
            controller: disHalf,
            hintText: "เลือกระยะทาง",
            enabled: true,
            itemsVisibleInDropdown: 3,
            items: half,
            textStyle: TextStyle(color: Colors.black),
            onValueChanged: (value) {
              setState(() {
                kmDrop = value;
              });
            }),
      ),
    );
  }

  Align fullWidget() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: DropDownField(
            controller: disFull,
            hintText: "เลือกระยะทาง",
            enabled: true,
            itemsVisibleInDropdown: 3,
            items: full,
            textStyle: TextStyle(color: Colors.black),
            onValueChanged: (value) {
              setState(() {
                kmDrop = value;
              });
            }),
      ),
    );
  }
}

String select = '';
final typeRunSelect = TextEditingController();

List<String> typeRun = [
  "Fun Run",
  "Mini",
  "Half",
  "Full",
];

String myFun = '';
final disFun = TextEditingController();
List<String> fun = ["3", "4", "5"];

String myMi = '';
final disMi = TextEditingController();
List<String> mi = [
  "10",
  "11",
];

String myHalf = '';
final disHalf = TextEditingController();
List<String> half = [
  "20",
  "21",
];

String myFull = '';
final disFull = TextEditingController();
List<String> full = [
  "40",
  "42",
];

class Dialog {
  waiting(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Navigator.of(context).pop();
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(description),
                ],
              ),
            ),
          );
        });
  }
}
