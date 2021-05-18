import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestAllScreen extends StatefulWidget {
  @override
  _TestAllScreenState createState() => _TestAllScreenState();
}

class _TestAllScreenState extends State<TestAllScreen> {

  SystemInstance _systemInstance = SystemInstance();
  List<Runner> runs = List();

  Future _getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_all/show?type=Mini',headers: header );
    var _data = jsonDecode(data.body);
    print(_data);
    for(var i in _data){
      Runner run = Runner(
          i["aid"],
          i["distance"],
          i["type"],
          i["dateStart"],
          i["dateEnd"],
      );
      runs.add(run);
    }
    print(runs);
    return runs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fun Run'),
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
      body: Container(
        child: FutureBuilder(
            future: _getData(),
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Padding(padding: EdgeInsets.all(0),);
              } else {
                return ListView.builder(
                  // itemBuilder: getItem ,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        // color: Colors.red[100],
                        child: InkWell(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.add_circle),
                                title: Text('ระยะทาง ' + snapshot.data[index].distance +' กิโลเมตร'),
                                subtitle: Text(' จากวันที่ ' + snapshot.data[index].dateStart + ' ถึงวันที่ '
                                    + snapshot.data[index].dateEnd),
                                onTap: () {
                                  // int aId = snapshot.data[index].aid;
                                  // print(aId);
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             RegisterRun(aaid: aId,)));
                                },
                              ),
                            ],
                          ),
                        ),

                      );
                    }

                );
              }
            }
        ),
      ),
    );
  }
}

class Runner{
  final int id;
  final String distance;
  final String type;
  final String dateStart;
  final String dateEnd;

  Runner(this.id, this.distance, this.type, this.dateStart, this.dateEnd);
}
