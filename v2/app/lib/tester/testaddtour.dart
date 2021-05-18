import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/tester/datefield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
class TestAddTour extends StatefulWidget {
  @override
  _TestAddTourState createState() => _TestAddTourState();
}

class _TestAddTourState extends State<TestAddTour> {
  final format = DateFormat.yMd();
  DateTime _date = new DateTime.now();
  DateTime _dateTime = new DateTime.now();
  var myDate = 'ยังไม่ได้เลือก';
  var myEndDate = 'ยังไม่ได้เลือก';

  TextEditingController km = TextEditingController();
  TextEditingController time = TextEditingController();
  String dropdown = 'Fun Run';
  SystemInstance _systemInstance = SystemInstance();

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

  void add() {
    Map params = Map();
    params["distance"] = km.text;
    params["type"] = dropdown;
    params["dateStart"] = myDate;
    params["dateEnd"] = myEndDate;
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/test_all/save',headers: header, body: params).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      // SystemInstance systemInstance = SystemInstance();
      // systemInstance.aid = resMap["aid"];
      // _fileUtil.writeFile(systemInstance.aid);
      showCustomDialog(context);
      setState(() {});
    });
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
    );
    if( picker!= null){
      print('Date:${_date.toString()}');
      setState(() {
        _date = picker;
        myDate = ("${_date.day}/${_date.month}/${_date.year}");
      });
    }
  }
  Future<Null> _selectEndDate(BuildContext context)async{
    final DateTime picked  = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
    );
    if(picked!=null){
      setState(() {
        _dateTime = picked;
        myEndDate = ("${_dateTime.day}/${_dateTime.month}/${_dateTime.year}");
      });
    }
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
                    controller: km,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ระยะทาง',
                    ),
                  ),
                ),
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
                          Text('เลือกวันที่เริ่มต้น',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.black),),
                          IconButton(
                            icon: Icon(Icons.date_range),
                            iconSize: 50,
                            color: Colors.green,
                            onPressed: () => _selectDate(context),
                          ),
                          Text("${myDate}"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('เลือกวันสิ้นสุด',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.black),),
                          IconButton(
                            icon: Icon(Icons.date_range),
                            iconSize: 50,
                            color: Colors.red,
                            onPressed: () => _selectEndDate(context),
                          ),
                          Text("${myEndDate}"),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: DropDownField(
                    controller: typeRunSelect,
                    hintText: "เลือกรายการที่เปิดรับสมัคร",
                    enabled: true,
                    itemsVisibleInDropdown: 5,
                    items: typeRun,
                    textStyle: TextStyle(color: Colors.black),
                    onValueChanged: (value){
                      setState(() {
                        dropdown = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 24),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('เพิ่ม'),
                      onPressed: () {
                        add();
                      },
                    )
                ),

              ],
            )
        )
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


