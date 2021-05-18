import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/rundata/datarunner.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowDataScreen extends StatefulWidget {
  final String km;
  final int myCal;
  final String time;

  const ShowDataScreen({Key key, this.km,this.myCal,this.time}) : super(key: key);

  @override
  _ShowDataScreenState createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  var consum = "00:00:00";
  var sumk = "0.0";
  var cal;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cal = widget.myCal;
    consum = widget.time;
    sumk = widget.km;
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลรวมของผู้ใช้'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('${sumk}',textAlign: TextAlign.center,style: TextStyle(fontSize: 35),
                    ),
                  ),
                  Expanded(
                    child: Text('${cal}',textAlign: TextAlign.center,style: TextStyle(fontSize: 35),
                    ),
                  ),
                  Expanded(
                    child: Text('${consum}',textAlign: TextAlign.center,style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('กิโลเมตร',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Expanded(
                    child: Text('แคลอรี่',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Expanded(
                    child: Text('เวลา',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              // Row(
              //   children: <Widget>[
              //
              //     Expanded(
              //       child: Text('0 ม.', textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
              //     ),
              //     Expanded(
              //       child: Text('--',textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Text('แคลอรี่', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              //
              //     ),
              //     Expanded(
              //       child: Text('วิ่งไต่ระดับ', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              //     ),
              //     Expanded(
              //       child: Text('ครั้งต่อนาที',textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              //     ),
              //   ],
              // ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: Colors.grey[800],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataRunnerNow {
  final int id;
  final int userId;
  final String km;
  final String type;
  final String dateNow;

  DataRunnerNow(this.id, this.userId, this.km, this.type, this.dateNow);
}
