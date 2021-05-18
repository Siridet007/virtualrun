import 'package:app/ui/newsdata/eventadmin/howadd.dart';
import 'package:app/ui/newsdata/eventadmin/howdelete.dart';
import 'package:app/ui/newsdata/eventadmin/howsee.dart';
import 'package:flutter/material.dart';

class HowToUseEventScreen extends StatefulWidget {
  @override
  _HowToUseEventScreenState createState() => _HowToUseEventScreenState();
}

class _HowToUseEventScreenState extends State<HowToUseEventScreen> {
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
                      Text('    รวมทุกวิธีการใช้งานของแอปพลิเคชันในส่วนของผู้จัดงาน ไว้ที่นี่ที่เดียว โดยจะแบ่งออกเป็น \n     การเพิ่มรายการวิ่ง การลบรายการวิ่ง ดูข้อมูลผู้วิ่ง',style: TextStyle(color: Colors.black,fontSize: 15),),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.asset(
                            'assets/images/howevent.png',
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
                          child: Text('เพิ่มรายการวิ่ง'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HowToAdd()));
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
                        child: Text('ลบรายการวิ่ง'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HowToDelete()));
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
                          child: Text('ดูข้อมูลผู้วิ่ง'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HowToSee()));
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
