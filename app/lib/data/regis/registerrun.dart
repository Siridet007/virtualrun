import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/util/file_util.dart';
import 'package:app/system/SystemInstance.dart';
import 'dart:convert';
import 'package:app/config/config.dart';
import 'package:image_picker/image_picker.dart';

class RegisterRun extends StatefulWidget {
  final int aaid;
  final String name;
  final String dis;
  final String dates;
  final String datee;
  final String price;

  const RegisterRun({Key key, this.aaid, this.name, this.dis, this.dates, this.datee,this.price}) : super(key: key);



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterRun();
  }
}

class _RegisterRun extends State<RegisterRun> {
  TextEditingController userNameFun = TextEditingController();
  TextEditingController passWordFun = TextEditingController();
  FileUtil _fileUtil = FileUtil();
  SystemInstance _systemInstance = SystemInstance();
  var userId;
  int _distancing = 0;
  String userName;
  int aID;
  var nameAll;
  var km;
  var myDate;
  var myEndDate;
  final picker = ImagePicker();
  var pickedFile;
  File _image;
  String size = '';
  var status = "0";
  var price;

  @override
  void initState(){
    super.initState();
    SystemInstance systemInstance = SystemInstance();
//    aid = systemInstance.aid.toString();
    userId = systemInstance.userId.toString();
    userName = systemInstance.userName;

    // _fileUtil.readFile().then((aid){
    //   this._aid = aid;
    //   print('aid save ${_aid}');
    // });
  }
  Future getImage() async{
    pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50
    );
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
      )
  );


  void onClick(){
    Dio dio = Dio();
    Map<String, dynamic> params = Map();
    params['id'] = aID.toString();
    params['userId'] = userId.toString();
    params['size'] = size;
    params['status'] = status.toString();
    params['fileImg'] = MultipartFile.fromBytes(_image.readAsBytesSync(), filename: "filename.png");
    FormData formData = FormData.fromMap(params);
    dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}";
    dio.post('${Config.API_URL}/test_run/update',data: formData).then((res) {
      Map resMap = jsonDecode(res.toString()) as Map;
      print(resMap);
      var data = resMap['status'];
      if(data == 1){
        Navigator.pop(context);
        showCustomDialog(context);
        setState(() {});
      }else{
        CoolAlert.show(context: context, type: CoolAlertType.error, text: 'ทำรายการไม่สำเร็จ');
      }

    });
  }

  @override
  Widget build(BuildContext context)  {
    aID = widget.aaid;
    nameAll = widget.name;
    km = widget.dis;
    myDate = widget.dates;
    myEndDate = widget.datee;
    price = widget.price;
    print(price);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('สมัครวิ่ง'),
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
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'ลงทะเบียนเข้าแข่งขัน',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text('ชื่อรายการวิ่ง',style: TextStyle(color: Colors.black),),
                ),
                new Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                  ),
                  child: Text("$nameAll",style: TextStyle(color: Colors.black),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text('ระยะทาง',style: TextStyle(color: Colors.black),),
                ),
                new Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                  ),
                  child: Text("$km",style: TextStyle(color: Colors.black),),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('วันที่เริ่มวิ่ง -> ',style: TextStyle(color: Colors.black),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('$myDate',style: TextStyle(color: Colors.black),),
                    ),

                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('วันที่สิ้นสุดการวิ่ง -> ',style: TextStyle(color: Colors.black),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('$myEndDate',style: TextStyle(color: Colors.black),),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('ค่าลงทะเบียน -> ',style: TextStyle(color: Colors.black),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text('$price.-',style: TextStyle(color: Colors.black),),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: DropDownField(
                    controller: sizeSelect,
                    hintText: "เลือกขนาดเสื้อ",
                    enabled: true,
                    itemsVisibleInDropdown: 5,
                    items: mySize,
                    textStyle: TextStyle(color: Colors.black),
                    onValueChanged: (value){
                      setState(() {
                        size = value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text('ส่งใบเสร็จยืนยันการชำระเงิน',style: TextStyle(color: Colors.black),),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: _image == null ? Container(
                      child: Center(
                        child: Text('เลือกสลิปการโอน'),
                      ),
                      color: Colors.grey[200],
                      width: 250.0,
                      height: 250.0,
                    ):Image.file(_image),
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
                      child: Text('ลงทะเบียน'),
                      onPressed: () {
                        // onRegisterRun();
                        onClick();
                      },
                    )),
              ],
            )));
  }
}
String select = '';
final sizeSelect = TextEditingController();

List<String> mySize = [
  "S",
  "M",
  "L",
  "XL",
  "XXL",
];