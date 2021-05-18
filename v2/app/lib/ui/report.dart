import 'dart:io';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String dropdown = 'Fun Run';
  File _images;
  var pickedFile;
  final picker = ImagePicker();
  TextEditingController km = TextEditingController();
  TextEditingController time = TextEditingController();

  void sentReport(){
    Map params = Map();
    params["distance"] = km.text;
    params["time"] = time.text;
    params["type"] = dropdown;
  }
  @override
  Widget build(BuildContext context) {

    Future getImages()async{
      pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 300.0,maxWidth: 300.0);
      print('dgjdlkjlg');
      setState(() {
        if(pickedFile != null){
          _images = File(pickedFile.path);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ส่งผลการวิ่ง'),
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
      body: SingleChildScrollView(

        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   child: DropdownButtonFormField<String>(
              //     hint: Text('เลือกรายการที่ลงสมัคร'),
              //     value: dropdown,
              //     iconSize: 20,
              //     elevation: 16,
              //     style: TextStyle(color: Colors.deepPurple),
              //
              //     onChanged: (String newValue){
              //       setState(() {
              //         dropdown = newValue;
              //       });
              //     },
              //     items: <String>['Fun Run', 'Mini', 'Half', 'Full']
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: DropDownField(
                  controller: typeRunSelect,
                  hintText: "เลือกรายการที่ลงสมัคร",
                  enabled: true,
                  itemsVisibleInDropdown: 5,
                  items: typeRun,
                  textStyle: TextStyle(color: Colors.black),
                  onValueChanged: (value){
                    setState(() {
                      select = value;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: _images == null ? Container(
                    child: Center(
                      child: Text('หลักฐานการวิ่ง'),
                    ),
                    color: Colors.grey[200],
                    width: 250.0,
                    height: 250.0,
                  ):Image.file(_images),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                child: Container(

                  child: RaisedButton.icon(
                    label: Text('เพิ่มรูปภาพ'),
                    icon: Icon(Icons.add_a_photo),
                    onPressed: getImages,
                  ),
                ),
              ),
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
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: time,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'เวลา',
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 410,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('เพิ่ม'),
                  onPressed: () {

                  },
                )
              ),
            ],
          ),
        ),
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
