import 'package:app/user/regisadmin.dart';
import 'package:app/user/register.dart';
import 'package:app/user/registersuper.dart';
import 'package:flutter/material.dart';
class SelectScreen extends StatefulWidget {
  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  TextEditingController pass = TextEditingController();

  Future showCustomDialogAdvice(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Icon(Icons.edit),
      content: new Row(
        children: [
          new Expanded(
            child: new TextField(
              controller: pass,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'ใส่รหัสผ่าน',),
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            check();


        },

          child: Text('ส่ง'),
        )
      ],
    ),

  );
  Future showCustomDialogNotAllow(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('รหัสผ่านไม่ถูกต้อง'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      ));

  void check(){
    print(pass);
    if(pass.text != '1234'){
      showCustomDialogNotAllow(context);
    }else{
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterSuperScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Virtual Run'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              showCustomDialogAdvice(context);
            //
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.cyan],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child:Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 32
                ),
                child: Center(
                  child: Image.asset('assets/images/runner.png'),
                ),
              ),
              Container(
                margin:EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),

                      ),
                      ListTile(
                        leading: Icon(Icons.directions_run),
                        title: Text('สำหรับนักวิ่ง'),
                        subtitle: Text('เมื่อสมัครเป็นสมาชิกในฐานะนักวิ่งแล้ว ท่านจะสามารถใช้งานแอปพลิเคชัน Virtual Run '),
                      )
                    ],
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 50,
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Register()));
                    },
                    child: Text(
                      'สำหรับนักวิ่ง',style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                  ),
                ),
              ),
              Container(
                margin:EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),

                      ),
                      ListTile(
                        leading: Icon(Icons.directions_run),
                        title: Text('สำหรับผู้จัดงาน'),
                        subtitle: Text('เมื่อสมัครเป็นสมาชิกในฐานะผู้จัดงาน ท่านจะสามารถใช้สร้างรายการวิ่งต่าง ๆ ได้ แต่จะมีค่าบริการสำหรับผู้จัดงาน'),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterAdminScreen()));
                    },
                    child: Text(
                      'สำหรับผู้จัดงาน',style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
