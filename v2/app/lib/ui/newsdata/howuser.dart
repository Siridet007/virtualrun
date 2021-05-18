import 'package:app/ui/newsdata/regisrun/howprofile.dart';
import 'package:app/ui/newsdata/regisrun/howtoregis.dart';
import 'package:app/ui/newsdata/regisrun/runnn.dart';
import 'package:app/util/constants.dart';
import 'package:app/util/responsive_screen.dart';
import 'package:app/widget/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:app/util/utils.dart';

import 'intro.dart';

class HowToUseUserScreen extends StatefulWidget {
  @override
  _HowToUseUserScreenState createState() => _HowToUseUserScreenState();
}

class _HowToUseUserScreenState extends State<HowToUseUserScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('วิธีใช้งาน'),
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
      body: Center(
        child: Column(
          children: [
            Container(
              margin:EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                    children: <Widget>[
                      Text('วิธีการใช้งาน',style: TextStyle(color: Colors.black,fontSize: 50,),textAlign: TextAlign.center,),
                      Divider(
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey[800],
                      ),
                      Text('    รวมทุกวิธีการใช้งานของแอปพลิเคชันในส่วนของนักวิ่ง ไว้ที่นี่ที่เดียว โดยจะแบ่งออกเป็น \n     การสมัครวิ่ง การวิ่ง แก้ไขโปรไฟล์',style: TextStyle(color: Colors.black,fontSize: 15),),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.asset(
                            'assets/images/howtouser.jpg',
                            width: 200,
                            height: 200,
                            fit:BoxFit.fill

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 50, 10, 10),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 140,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('สมัครวิ่ง'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HowToRegister()));
                          },
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 10, 10),
                  child: Container(
                      height: 50,
                      width: 140,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('การวิ่ง'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HowToRunScreen()));
                        },
                      )
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 10, 10, 10),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 140,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('แก้ไขโปรไฟล์'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HowToProfile()));
                          },
                        )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
