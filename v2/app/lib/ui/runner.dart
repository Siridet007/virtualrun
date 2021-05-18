import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/run/km.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/rundata/datarunner.dart';
import 'package:app/ui/running.dart';
import 'package:app/util/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class Runner extends StatefulWidget {
  @override
  _RunnerState createState() => _RunnerState();
}

class _RunnerState extends State<Runner> {
  SystemInstance _systemInstance = SystemInstance();
  final _date = new DateTime.now();

  List<DataRun> dataRuns = List();
  final List<String> _list = List<String>.generate(20, (index) => "Item: ${++index}");
  List _lst = List();
  var id;
  var isType;
  var dateS;
  var dateE;
  var distance;
  List aaa = List();
  List<DataRunner> _listKm = List();
  SystemInstance _instance = SystemInstance();
  bool _isLoading = true;

  @override
  void initState(){
    SystemInstance systemInstance = SystemInstance();
    id = systemInstance.userId;
    print(id);
    print(_systemInstance.token);
    _getData();
    super.initState();
  }

  Future _getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/test_run/test_show?userId=${id}',headers: header );
    if(data.statusCode == 200) {
      _isLoading = false;
      var _data = jsonDecode(data.body);
      var sum = _data['data'];
      // print(_data);
      // print(sum);
      for (var i in sum) {
        print(i);
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
    }else{
      _isLoading = false;
      setState(() {

      });
    }
    // return dataRuns;
  }
  Future showCustomDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text('ไม่ตรงตามเงื่อนไขที่กำหนด'),
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

    // print("ID${id}");
    //show();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการที่ลงทะเบียนไว้'),
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
              return Container(
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
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    KilometerScreen(id: aaId,type:isType,km:distance,dateS: dateS,dateE: dateE,)));

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
              );
            }
        ),
      ),








      // Container(
      //     child:FutureBuilder(
      //               future: _getData(),
      //               builder: (BuildContext context, AsyncSnapshot snapshot) {
      //                    if(snapshot.data == null){
      //                      return Center(
      //                        child: Padding(
      //                          padding: EdgeInsets.all(0),
      //                          child: Loading(
      //                            indicator: BallPulseIndicator(),
      //                            size: 100.0,color: Colors.pink,
      //                          ),
      //                        ),
      //                      );
      //                    } else {
      //                      return ListView.builder(
      //                          shrinkWrap: true,
      //                          // itemBuilder: getItem ,
      //                          itemCount: snapshot.data.length,
      //                          itemBuilder: (BuildContext context, int index) {
      //                            return Card(
      //                              shape: RoundedRectangleBorder(
      //                                  borderRadius:
      //                                  BorderRadius.all(Radius.circular(8.0))),
      //                              child: ListTile(
      //                                leading: Container(
      //                                  height: 50.0,
      //                                  width: 50.0,
      //                                  child: FadeInImage(
      //                                    placeholder: AssetImage('assets/images/loading.gif'),
      //                                    image: NetworkImage(
      //                                        '${Config.API_URL}/test_all/image?imgAll=${snapshot.data[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
      //                                    ),
      //                                    fit: BoxFit.cover,
      //                                  ),
      //                                ),
      //                                title: Text('${snapshot.data[index].nameAll}'),
      //                                subtitle: Text(' จากวันที่ ' + snapshot.data[index].dateStart + ' ถึงวันที่ '
      //                                    + snapshot.data[index].dateEnd),
      //                                onTap: () {
      //                                  int aaId = snapshot.data[index].id;
      //                                  print("allRunId = $aaId");
      //                                  distance = snapshot.data[index].distance;
      //                                  isType = snapshot.data[index].type;
      //                                  dateS = snapshot.data[index].dateStart;
      //                                  dateE = snapshot.data[index].dateEnd;
      //                                  print(distance);
      //                                  var conS = new DateFormat('dd/mm/yyyy').parse(dateS);
      //                                  var conE = new DateFormat('dd/mm/yyyy').parse(dateE);
      //                                  print("conS $conS");
      //                                  print("conE $conE");
      //                                  var conN = new DateTime.now();
      //                                  var date2s = ('${_date.day}/${_date.month}/${_date.year}');
      //                                  var s2date = new DateFormat('dd/mm/yyyy').parse(date2s);
      //                                  var dateN2s = ('${conN.day}/${conN.month}/${conN.year}');
      //                                  var s2dateN = new DateFormat('dd/mm/yyyy').parse(dateN2s);
      //                                  var ds = ('29/01/2021');
      //                                  var de = ('31/01/2021');
      //                                  var ds2d = new DateFormat('dd/mm/yyyy').parse(ds);
      //                                  var de2d = new DateFormat('dd/mm/yyyy').parse(de);
      //                                  print("s2date $s2date");
      //                                  print("s2dateN $s2dateN");
      //                                  if((s2date==conS || s2date.isAfter(conS)) && (s2date==conE || s2date.isBefore(conE))){
      //                                    print('0');
      //                                    // Navigator.push(
      //                                    //     context,
      //                                    //     MaterialPageRoute(
      //                                    //         builder: (BuildContext context) =>
      //                                    //             Running(idrunner: aaId,isType:isType)));
      //                                    Navigator.push(
      //                                        context,
      //                                        MaterialPageRoute(
      //                                            builder: (BuildContext context) =>
      //                                                KilometerScreen(id: aaId,type:isType,km:distance ,)));
      //                                  }else{
      //                                    print('1');
      //                                    showCustomDialog(context);
      //                                  }
      //                                },
      //                              ),
      //                            );
      //                          });
      //                    }
      //               }),
      //     ),
    );
  }
}

class DataRun {
  final int id;
  final String nameAll;
  final String distance;
  final String type;
  final String dateStart;
  final String dateEnd;
  final String imgAll;

  DataRun(this.id, this.nameAll, this.distance, this.type, this.dateStart, this.dateEnd, this.imgAll);



}
