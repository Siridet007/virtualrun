import 'dart:convert';
import 'dart:io';

import 'package:app/config/config.dart';
import 'package:app/setting/setting.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/util/responsive_screen.dart';
import 'package:app/widget/waveclipperone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TestPro extends StatefulWidget {
  @override
  _TestProState createState() => _TestProState();
}

class _TestProState extends State<TestPro> {
  Screen size;
  String userName;
  var pickedFile;
  final picker = ImagePicker();
  File _images;
  SystemInstance _systemInstance = SystemInstance();
  var id;
  var name;

  Future getData() async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$id',
        headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    for (var i in sum) {
      name = i['name'];
    }
    print(name);
    return name;
  }

  @override
  void initState() {
    SystemInstance systemInstance = SystemInstance();
    id = systemInstance.userId;
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemInstance systemInstance = SystemInstance();
    userName = systemInstance.userName;
    size = Screen(MediaQuery.of(context).size);

    Future getImages() async {
      pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 300.0, maxWidth: 300.0);
      print('dgjdlkjlg');
      setState(() {
        if (pickedFile != null) {
          _images = File(pickedFile.path);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Setting()));
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: ClipPath(
                  clipper: WaveClipperOne(),
                  child: Container(
                    height: 250,
                    color: Colors.pink[100],
                    child: Container(
                      child: Column(
                        children: [
                          profileWidget(),
                          Text(
                            '${userName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text(
                    'ระยะทางทั้งหมด',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '0.00',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'กิโลเมตร',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: Colors.grey[800],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.golf_course,
                        size: 50,
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.timeline,
                        size: 50,
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.av_timer,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '00:00',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '00:00',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'ชาเลนจ์',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'เวลาเฉลี่ย',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'เวลารวม',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align profileWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: size.getWidthPx(60)),
        child: CircleAvatar(
          foregroundColor: Colors.white,
          maxRadius: size.getWidthPx(50),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            maxRadius: size.getWidthPx(48),
            foregroundColor: Color.fromRGBO(97, 10, 155, 0.6),
            backgroundImage: NetworkImage(
                'https://www.img.in.th/images/db548302a0dced5295399866fcd9594c.jpg'),
          ),
        ),
      ),
    );
  }
}
