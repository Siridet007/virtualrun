import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/runner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class OldRunScreen extends StatefulWidget {
  const OldRunScreen({Key key}) : super(key: key);

  @override
  _OldRunScreenState createState() => _OldRunScreenState();
}

class _OldRunScreenState extends State<OldRunScreen> {


  SystemInstance _systemInstance = SystemInstance();
  final _date = new DateTime.now();

  List<DataRun> dataRuns = List();
  List _list = [];
  List _lst = List();
  var id;
  var isType;
  var dateS;
  var dateE;
  var distance;
  List aaa = List();
  SystemInstance _instance = SystemInstance();
  bool _isLoading = true;

  @override
  void initState(){
    SystemInstance systemInstance = SystemInstance();
    id = systemInstance.userId;
    print(id);
    print(_systemInstance.token);
    _getData();
    checkId();
    super.initState();
  }

  Future _getData()async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/test_run/test_show?userId=${id}', headers: header);
    if (data.statusCode == 200) {
      _isLoading = false;
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      // print(_data);
      // print(sum);
      for (var i in sum) {
        // print(i);
        DataRun run = DataRun(
          i["id"],
          i["nameAll"],
          i["distance"],
          i["type"],
          i["dateStart"],
          i["dateEnd"],
          i["imgAll"],
        );
        // print("sada: ${run}");
        dataRuns.add(run);
      }
      // print("Run: ${dataRuns}");
      setState(() {

      });
      return dataRuns;
    } else {
      _isLoading = false;
      setState(() {

      });
    }
  }

  Future checkId() async {
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/ranking/show?UserId=$id',
        headers: header);
    var _data = jsonDecode(data.body);
    print(data);
    var sum = _data['data'];
    print("_data $sum");
    for (var i in sum) {
      var ggg = i['id'];
      // MyRunner myRunner = MyRunner(
      //     i['rid'],
      //     i['userId'],
      //     i['id'],
      //     i['size'],
      //     i['createDate'],
      //     i['status'],
      //     i['imgSlip'],
      //   i['isRegister']
      // );
      print("ggg$ggg");
      _list.add(ggg);
    }
    setState(() {});
    print("myrun $_list");
    return _list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการที่วิ่งเสร็จแล้ว'),
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
        child: _isLoading ? Center(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Loading(
              indicator: BallPulseIndicator(),
              size: 100.0,
              color: Colors.pink,
            ),
          ),
        ): ListView.builder(
            itemCount: dataRuns.length,
            itemBuilder: (BuildContext context, int index){
              print('data');
              print(dataRuns[index].id);
              print(_list.contains(dataRuns[index].id));
              return _list.contains(dataRuns[index].id) == true ? Container(
                margin:EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: InkWell(
                    onTap: () {
                      int aaId = dataRuns[index].id;
                      print("allRunId = $aaId");
                      distance = dataRuns[index].distance;
                      isType = dataRuns[index].type;
                      dateS = dataRuns[index].dateStart;
                      dateE = dataRuns[index].dateEnd;
                      print(distance);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             KilometerScreen(id: aaId,type:isType,km:distance,dateS: dateS,dateE: dateE,)));

                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/loading.gif'),
                            image: NetworkImage(
                              '${Config.API_URL}/test_all/image?imgAll=${dataRuns[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                            ),
                            width: 350,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text("รายการ "+dataRuns[index].nameAll +" ระยะทาง "+ dataRuns[index].distance),
                          subtitle: Text(' จากวันที่ ' + dataRuns[index].dateStart + ' ถึงวันที่ '
                              + dataRuns[index].dateEnd),

                        ),
                      ],
                    ),
                  ),

                ),
              ): Padding(padding: EdgeInsets.zero);
            }
        ),
      ),
    );
  }
}
