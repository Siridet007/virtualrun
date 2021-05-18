import 'package:flutter/material.dart';
class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('ส่งเรียบร้อย'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ติดต่อสอบถาม'),
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
                    '',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  // controller: userName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อ-นามสกุล',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  // controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'อีเมลของท่าน',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  // controller: tel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'เบอร์โทรศัพท์',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                child: TextField(
                  // controller: tel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'เรื่องที่ต้องการติดต่อ',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('ติดต่อเรา'),
                  onPressed: () {
                    showCustomDialog(context);
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
