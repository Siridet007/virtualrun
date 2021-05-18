import 'dart:async';
import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/data/add.dart';
import 'package:app/setting/profile/editpass.dart';
import 'package:app/setting/profile/editprofile.dart';
import 'package:app/ui/profile.dart';
import 'package:app/user/login.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/util/utils.dart';
import 'package:app/widget/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  static const routeName = '/setting';

  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
  String _name;
  bool isLocalNotification = false;
  bool isPushNotification = true;
  bool isPrivateAccount = true;
  String userName;
  SharedPreferences sharedPreferences;
  SystemInstance _systemInstance = SystemInstance();
  var img;
  var id;
  FileUtil _fileUtil = FileUtil();

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(Icons.email),
        content: Text("siridet.wo@rmuti.ac.th   0934576814"),

        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      ),

  );
  Future showCustomDialogAdvice(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Icon(Icons.edit),
      content: new Row(
        children: [
          new Expanded(
            child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'ข้อเสนอแนะ',),
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ส่ง'),
        )
      ],
    ),

  );

  @override
  void initState() {
    // TODO: implement initState
    SystemInstance systemInstance = SystemInstance();

    getSharedPreference();
    super.initState();
  }
  Future getSharedPreference()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    // userName = systemInstance.userName;
    // _name = userName;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ตั้งค่า",),
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
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,),
        child: Container(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                accountSection(),
                // pushNotificationSection(),
                getHelpSection(),
              ],
            ),
          ),
        ),
      ),

    );
  }

  SettingSection getHelpSection() {
    return SettingSection(
      headerText: "ศูนย์ช่วยเหลือ".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: TileRow(
            label: "ติดต่อเรา",
            disableDivider: false,
            onTap: () {
              print("aaa");
              showCustomDialog(context);
            },
          ),
        ),
        Container(
          child: TileRow(
            label: "ข้อเสนอแนะ",
            disableDivider: false,
            onTap: () {
              print("aaa");
              showCustomDialogAdvice(context);
            },
          ),
        ),
        Container(
          child: TileRow(
            label: "ลงชื่อออก",
            disableDivider: false,
            onTap: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => Login()),
                      (Route<dynamic> route) => false);
            },
          ),
        )
      ],
    );
  }

  SettingSection accountSection() {
    return SettingSection(
      headerText: "บัญชี".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
            child: TileRow(
              label: "แก้ไขบัญชี",
              // disabled: true,
              // rowValue: "${_name}",
              // disableDivider: true,
              onTap: () {
                print("dasd");
                Navigator.push(context,MaterialPageRoute(builder: (context) => EditScreen()));
              },
            ),
        ),
        // Container(
        //   child: TileRow(
        //     label: "เปลี่ยนรหัสผ่าน",
        //     disableDivider: false,
        //     onTap: () {
        //       print("aaa");
        //       // Navigator.push(context,MaterialPageRoute(builder: (context) => EditPassWordScreen()));
        //     },
        //   ),
        // )
      ],
    );
  }

  SettingSection pushNotificationSection() {
    return SettingSection(
      headerText: "การแจ้งเตือน".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: SwitchRow(
            label: "แจ้งเตือน",
            disableDivider: false,
            value: isPushNotification,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus
                    ? isPushNotification = true
                    : isPushNotification = false;
              });
            },
            onTap: () {},
          ),
        ),
      ],
    );
  }
}