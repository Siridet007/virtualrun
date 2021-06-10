import 'dart:convert';
import 'dart:io';

import 'package:app/config/config.dart';
import 'package:app/data/infodata.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditDataScreen extends StatefulWidget {
  final int aaid;
  final String name;
  final String type;
  final String km;
  final String dateS;
  final String dateE;
  final String img;
  final String acces;
  final String price;

  const EditDataScreen(
      {Key key,
      this.aaid,
      this.name,
      this.type,
      this.km,
      this.dateS,
      this.dateE,
      this.img,
        this.acces,
      this.price})
      : super(key: key);

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final format = DateFormat.yMd();
  DateTime _date = new DateTime.now();
  DateTime _dateTime = new DateTime.now();
  var myDate = 'ยังไม่ได้เลือก';
  var myEndDate = 'ยังไม่ได้เลือก';
  TextEditingController nameAll = TextEditingController();
  TextEditingController km = TextEditingController();
  TextEditingController time = TextEditingController();
  String dropdown = 'Fun Run';
  SystemInstance _systemInstance = SystemInstance();
  File _image;
  File _f;
  final picker = ImagePicker();
  var pickedFile;
  var userId;
  SystemInstance systemInstance = SystemInstance();
  var aid;
  var kmDrop = '';
  var myName;
  var imgAll;
  TextEditingController price = TextEditingController();
  TextEditingController accessories = TextEditingController();
  var myPrice;
  var myAccess;
  bool canDelete = false;
  int rad;
  var accc;

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

  Future getImage() async {
    pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
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

  Future showCustomDialogDelete(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('ต้องการลบรายการนี้หรือไม่'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'ไม่',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () => {
                  removeList(),
                  Navigator.of(context).pop(),
                },
                child: Text(
                  "ใช่",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ));

  Future showCustomDialogDeleteSuccess(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('ลบสำเร็จ'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              )
            ],
          ));
  Future showCustomDialogCannotDelete(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ไม่สามารถลบได้ เนื่องจากมีผู้สมัครรายการนี้แล้ว'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      ));
  Future showCustomDialogCannotEdit(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ไม่สามารถแก้ไขได้ เนื่องจากมีผู้สมัครรายการนี้แล้ว'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      ));
  removeList() async {
    print("remove");
    print(aid);
    print(userId);
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/test_all/remove?id=${aid}&userId=${userId}',
        headers: header);
    print(data);
    var jsonData = json.decode(data.body);
    if (jsonData['status'] == 0) {
      print("remove แล้ว");
      Navigator.pop(context);
      showCustomDialogDeleteSuccess(context);
      setState(() {});
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'ไม่ใช่รายการที่ท่านสร้าง ไม่สามารถลบได้');
    }
  }
  Future getCheck() async{
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post('${Config.API_URL}/test_run/load_check?id=$aid',
        headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    List sum = _data['data'];
    print(sum);
    if(sum.length == 0){
      canDelete = true;
    }else{
      canDelete = false;
    }
    setState(() {

    });
    print(canDelete);
  }


  void add() {
    print(userId);
    var isName;
    var isPrice;
    var isAcces;
    if (nameAll.text.isEmpty) {
      isName = myName;
    } else {
      isName = nameAll.text;
    }
    if (price.text.isEmpty) {
      isPrice = myPrice;
    } else {
      isPrice = price.text;
    }
    if(accessories.text.isEmpty){
      isAcces = myAccess;
    }else{
      isAcces = accessories.text;
    }
    var aa;
    if(accessories == "เสื้อ"){
      print("$accessories");
    }
    if(rad == 0){
      aa = "shirt";
    }else if(rad == 1){
      aa = "hat";
    }else if(rad == 2){
      aa = "bag";
    }else{
      aa = "non";
    }
    Dio dio = Dio();
    Map<String, dynamic> params = Map();
    params['id'] = aid;
    params['nameAll'] = isName.toString();
    params["distance"] = kmDrop;
    params["type"] = dropdown;
    params["dateStart"] = myDate;
    params["dateEnd"] = myEndDate;
    params["userId"] = userId.toString();
    params["accessories"] = aa.toString();
    params["price"] = isPrice.toString();
    params['fileImg'] = MultipartFile.fromBytes(_image.readAsBytesSync(),
        filename: "filename.png");
    FormData formData = FormData.fromMap(params);
    // Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}";
    print(
        "adsad${dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}"}");
    dio
        .post('${Config.API_URL}/test_all/update_list', data: formData)
        .then((res) {
      Map resMap = jsonDecode(res.toString()) as Map;
      // SystemInstance systemInstance = SystemInstance();
      // systemInstance.aid = resMap["aid"];
      // _fileUtil.writeFile(systemInstance.aid);
      var data = resMap['status'];
      if (data == 1) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed("/Launcher");
        showCustomDialog(context);
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (BuildContext context) => Launcher()));
        // showCustomDialog(context);
        // setState(() {});
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'ทำรายการไม่สำเร็จ');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    userId = systemInstance.userId;
    //
    // DateTime defDate = new DateTime.now();
    // myDate = ("${defDate.day}/${defDate.month}/${defDate.year}");
    // DateTime defEndDate = new DateTime.now();
    // myEndDate = ("${defEndDate.day}/${defEndDate.month}/${defEndDate.year}");
    // nameAll = widget.name as TextEditingController;
    myName = widget.name;

    kmDrop = widget.km;
    dropdown = widget.type;
    myDate = widget.dateS;
    myEndDate = widget.dateE;
    imgAll = widget.img;
    myAccess = widget.acces;
    myPrice = widget.price;
    print(myName);
    print(kmDrop);
    print(dropdown);
    print(myDate);
    print(myEndDate);
    print(imgAll);
    print(myAccess);
    if(myAccess == "shirt"){
      accc = "เสื้อ";
      rad = 0;
    }else if(myAccess == "hat"){
      accc = "หมวก";
      rad = 1;
    }else if(myAccess == "bag"){
      accc = "ถุงผ้า";
      rad = 2;
    }else{
      accc = "ไม่มี";
      rad = 3;
    }
    aid = widget.aaid;
    print("aid $aid");
    getCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('แก้ไขรายการวิ่ง'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if(canDelete == false){
                showCustomDialogCannotDelete(context);
              }else if(canDelete == true){
                showCustomDialogDelete(context);
              }


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
        children: <Widget>[
          Container(
            alignment: FractionalOffset.topRight,
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => InfoDataScreen(
                              aid: aid,
                            )));
              },
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.person),
                  Text(
                    "รายชื่อผู้สมัคร",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'ชื่อรายการวิ่ง',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: TextField(
              controller: nameAll,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'ชื่อรายการวิ่ง',
                  hintText: "$myName"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: DropDownField(
              controller: typeRunSelect,
              hintText: "$dropdown",
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
          SizedBox(height: 24),

          Container(
            child: Column(
              children: [
                if (dropdown == 'Fun Run') ...[
                  funWidget(),
                ] else if (dropdown == 'Mini') ...[
                  miWidget(),
                ] else if (dropdown == 'Half') ...[
                  halfWidget(),
                ] else ...[
                  fullWidget(),
                ]
              ],
            ),
          ),
          SizedBox(height: 24),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   child: TextField(
          //     controller: km,
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: 'ระยะทาง',
          //     ),
          //   ),
          // ),
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
                  child: Text("หมวก",style: TextStyle(color: Colors.black),),
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
                  child: Text("ถุงผ้า",style: TextStyle(color: Colors.black),),
                ),
                Expanded(
                  child: Radio(
                    value: 3,
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
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'ราคาค่าสมัคร',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: TextField(
              controller: price,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'ชื่อรายการวิ่ง',
                  hintText: "$myPrice"),
            ),
          ),
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
          // SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: _image == null
                  ? Container(
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/loading.gif'),
                        image: NetworkImage(
                          '${Config.API_URL}/test_all/image?imgAll=${imgAll}',
                          headers: {
                            "Authorization": "Bearer ${_systemInstance.token}"
                          },
                        ),
                      ),
                    )
                  : Image.file(_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
            child: Container(
              child: RaisedButton.icon(
                label: Text('เปลี่ยนรูปภาพ'),
                icon: Icon(Icons.add_a_photo),
                onPressed: getImage,
              ),
            ),
          ),

          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('แก้ไข'),
                onPressed: () {
                  if(canDelete == false){
                    showCustomDialogCannotEdit(context);
                  }else if(canDelete == true){
                    if (nameAll.text.isNotEmpty |
                    dropdown.isNotEmpty |
                    km.text.isNotEmpty |
                    myDate.isNotEmpty |
                    myEndDate.isNotEmpty) {
                      add();
                    } else {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          text: 'กรุณากรอกข้อมูลให้ครบถ้วน');
                    }
                  }

                },
              )),
        ],
      ),
    );
  }

  Align funWidget() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DropDownField(
            controller: disFun,
            hintText: "$kmDrop",
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DropDownField(
            controller: disMi,
            hintText: "$kmDrop",
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DropDownField(
            controller: disHalf,
            hintText: "$kmDrop",
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DropDownField(
            controller: disFull,
            hintText: "$kmDrop",
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
