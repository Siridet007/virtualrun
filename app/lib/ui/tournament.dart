import 'dart:convert';

import 'package:app/config/config.dart';
import 'package:app/data/add.dart';
import 'package:app/data/editdata.dart';
import 'package:app/data/full.dart';
import 'package:app/data/half.dart';
import 'package:app/data/infodata.dart';
import 'package:app/data/mini.dart';
import 'package:app/data/oldlist.dart';
import 'package:app/data/regis/registerrun.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:app/ui/profile.dart';
import 'package:app/user/super.dart';
import 'package:app/util/file_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/funrun.dart';

class Tournament extends StatefulWidget {
  static const routeName = '/news';
  final int userId;

  const Tournament({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Tournament();
  }
}

class _Tournament extends State<Tournament> {
  FileUtil _fileUtil = FileUtil();
  var userId;
  var gg = 0;
  SharedPreferences sharedPreferences;
  var id;
  var stat = "";
  List<AllRunner> alls = [];
  List<MyRunner> runners = List();
  List _list = List();
  bool _isLoading = true;
  List myList = [];

  SystemInstance systemInstance = SystemInstance();
  SystemInstance _systemInstance = SystemInstance();

  var aaid;
  var nameAll;
  var dis;
  var type;
  var dates;
  var datee;
  var img;
  var accessories;
  var price;
  var myId;
  var isStat;
  var zzz;
  var allow;
  var userName;
  var passWord;
  var au;
  var name = '';
  var tel = '';
  var imgP;
  var autho;
  String token;
  final _date = new DateTime.now();
  var date2s;
  var s2date;
  var active;

  ScrollController _scrollController;

  Future showList() async {
    print("stat :$stat");
    date2s = ('${_date.day}/${_date.month}/${_date.year}');
    s2date = new DateFormat('d/M/yyyy').parse(date2s);
    myList = [
      {
        "id": "0",
        "nameAll": "xxx",
        "distance": "0",
        "type": "Fun Run",
        "dateStart": "1/1/2021",
        "dateEnd": "1/1/2021",
        "imgAll": "l.pmg",
        "userId": "1",
        "price": "0",
        "createDate": "2021-05-02T07:52:08.736+00:00"
      }
    ];
    print(myList);
    if (stat == "Admin") {
      print("admin");
      Map<String, String> header = {
        "Authorization": "Bearer ${_systemInstance.token}"
      };
      var res = await http.post(
          '${Config.API_URL}/test_all/show_all?userId=$userId',
          headers: header);
      var data = utf8.decode(res.bodyBytes);
      if (res.statusCode == 200) {
        _isLoading = false;
        var _data = jsonDecode(data);
        print(_data);
        for (var i in _data) {
          AllRunner allRunner = AllRunner(
              i['id'],
              i['userId'],
              i['nameAll'],
              i['distance'],
              i['type'],
              i['dateStart'],
              i['dateEnd'],
              i['imgAll'],
              i['price'],
              i['accessories'],
              i['active'],
              i['createDate']);
          // alls.add(allRunner);

          myList.add(allRunner);
        }
      } else {
        _isLoading = false;
        setState(() {});
      }
    } else if (stat == 'User') {
      Map<String, String> header = {
        "Authorization": "Bearer ${_systemInstance.token}"
      };
      var res =
          await http.post('${Config.API_URL}/test_all/load', headers: header);
      var data = utf8.decode(res.bodyBytes);
      if (res.statusCode == 200) {
        _isLoading = false;
        var _data = jsonDecode(data);
        print(_data);
        var sum = _data['data'];
        for (var i in sum) {
          AllRunner allRunner = AllRunner(
              i['id'],
              i['userId'],
              i['nameAll'],
              i['distance'],
              i['type'],
              i['dateStart'],
              i['dateEnd'],
              i['imgAll'],
              i['price'],
              i['accessories'],
              i['active'],
              i['createDate']);
          // alls.add(allRunner);
          var aa = i['active'];
          if(aa == 'yes'){
            var dd = i['dateStart'];
            var ddd = new DateFormat('d/M/yyyy').parse(dd);
            print("ddd $ddd");
            var ss = i['dateEnd'];
            var sss = new DateFormat('d/M/yyyy').parse(ss);
            print("sss $sss");
            if(s2date.isAfter(sss) ){

            }else{
              myList.add(allRunner);
            }
          }else{

          }
          // var dd = i['dateStart'];
          // var ddd = new DateFormat('d/M/yyyy').parse(dd);
          // print("ddd $ddd");
          // var ss = i['dateEnd'];
          // var sss = new DateFormat('d/M/yyyy').parse(ss);
          // print("sss $sss");
          // if(s2date.isAtSameMomentAs(ddd) && s2date.isBefore(ddd) || s2date.isAfter(sss) ){
          //
          // }else{
          //   myList.add(allRunner);
          // }
                  }
      } else {
        _isLoading = false;
        setState(() {});
      }
    } else if(stat == "super") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SuperAdminScreen()));
    }
    print("myList$myList");
    setState(() {});
    return myList;
  }

  // Future _get()async{
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   var data = await http.post('${Config.API_URL}/test_all/load',headers: header );
  //   if(data.statusCode == 200) {
  //     _isLoading = false;
  //     var _data = jsonDecode(data.body);
  //     print("all$_data");
  //     var sum = _data['data'];
  //     for (var i in sum) {
  //       AllRunner allRunner = AllRunner(
  //           i['id'],
  //           i['userId'],
  //           i['nameAll'],
  //           i['distance'],
  //           i['type'],
  //           i['dateStart'],
  //           i['dateEnd'],
  //           i['imgAll'],
  //           i['price'],
  //           i['createDate']
  //       );
  //       alls.add(allRunner);
  //       setState(() {
  //
  //       });
  //
  //     }
  //
  //   }else{
  //     _isLoading = false;
  //     setState(() {
  //
  //     });
  //   }
  //   return alls;
  // }

  Future getData() async {

    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    token = await firebaseMessaging.getToken();
    print("token $token");

    print("ididid$id");
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var res = await http.post(
        '${Config.API_URL}/user_profile/show?userId=$userId',
        headers: header);
    var data = utf8.decode(res.bodyBytes);
    var _data = jsonDecode(data);
    print(_data);
    var sum = _data['data'];
    for (var i in sum) {
      print(i);
      ProfileData(i['userId'], i['userName'], i['passWord'], i['au'], i['name'],
          i['tel'], i['imgProfile']);
      stat = i['au'];
      userName = i['userName'];
      passWord = i['passWord'];
      au = i['au'];
      name = i['name'];
      tel = i['tel'];
      imgP = i['imgProfile'];
      autho = i['autho'];
    }
    print(stat);

    showList();
    checkId();
    checkcheck();
    checkAllow();
    return stat;
  }

  Future getInfo() async {

    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    token = await firebaseMessaging.getToken();
    print("token $token");

    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var res = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var data = utf8.decode(res.bodyBytes);
    var _data = jsonDecode(data);
    print(_data);
    var sum = _data['data'];
    for (var i in sum) {
      print(i);
      stat = i['au'];
      userName = i['userName'];
      passWord = i['passWord'];
      au = i['au'];
      name = i['name'];
      tel = i['tel'];
      imgP = i['imgProfile'];
      autho = i['autho'];
    }
    setState(() {

    });
    // saveToken();
  }
  void saveToken(){
    Map params = Map();
    params['userId'] = userId.toString();
    params['userName'] = userName.toString();
    params['passWord'] = passWord.toString();
    params['name'] = name.toString();
    params['tel'] = tel.toString();
    params['au'] = au.toString();
    params['autho'] = autho.toString();
    params['imgProfile'] = imgP.toString();
    params['token'] = token.toString();
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    http.post('${Config.API_URL}/user_profile/update', body: params,headers: header).then((res) {
      Map resMap = jsonDecode(res.body) as Map;
      var data = resMap['status'];
      print(data);
      if (data == 0) {
        print("no");
      } else {
        // SystemInstance systemInstance = SystemInstance();
        // systemInstance.name = _name.text;
        print("success");
      }
    });
  }
  void check() {
    print("gggg$gg");
    if (gg == 0) {
      gg = userId;
      print("check");
      check();
    } else {
      print("go");
      getData();
    }
  }
  Future checkAllow() async{
    if(stat == "Admin"){
      Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
      var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
      var _data = jsonDecode(data.body);
      print(_data);
      var sum = _data['data'];
      for(var i in sum){
        allow = i['autho'];
      }
      print(allow);
    }
  }

  Future checkId() async {
    if (stat == "Admin") {
    } else {
      Map<String, String> header = {
        "Authorization": "Bearer ${_systemInstance.token}"
      };
      var data = await http.post(
          '${Config.API_URL}/test_run/show_run?userId=$userId',
          headers: header);
      var _data = jsonDecode(data.body);
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
    }
    setState(() {});
    print("myrun $_list");
    return _list;
  }

  Future checker() async {
    print(userId);
    print(aaid);
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/test_run/check?id=$aaid&userId=$userId',
        headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['status'];
    if (sum == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterRun(
                    aaid: aaid,
                    name: nameAll,
                    dis: dis,
                    dates: dates,
                    datee: datee,
                    price: price,
                access: accessories,
                active: active,
                  )));
    } else {
      showCustomDialogFailed(context);
    }
    setState(() {});
  }

  Future checkcheck() async {
    print(userId);
    print(aaid);
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post(
        '${Config.API_URL}/test_run/check?id=$aaid&userId=$userId',
        headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    var sum = _data['status'];
    if (sum == 1) {
      isStat = false;
    } else {
      isStat = true;
    }
    setState(() {});
    return isStat;
  }

  Future showCustomDialogFailed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('ท่านได้สมัครรายการนี้ไปแล้ว'),
            actions: [
              FlatButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                child: Text('ปิด'),
              )
            ],
          ));

  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('สำหรับระบบเท่านั้น'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              )
            ],
          ));
  Future showCustomDialogNotAllow(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('รอการอนุมัติก่อน จึงจะเพิ่มรายการได้'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      ));

  Future showCustomDialogEdit(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('เลือกรายการที่ต้อง'),
            actions: [
              FlatButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => InfoDataScreen(
                                aid: aaid,
                              ))),
                },
                child: Text(
                  'ดูรายชื่อผู้สมัคร',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  checkList(),
                  //
                },
                child: Text(
                  "แก้ไข",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ));

  Future checkList() async {
    print(aaid);
    var user;
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    var data = await http.post('${Config.API_URL}/test_all/show_id?id=$aaid',
        headers: header);
    var _data = jsonDecode(data.body);
    print(_data);
    for (var i in _data) {
      user = i['userId'];
    }
    print(user);
    print(userId);
    if (userId == user) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EditDataScreen(
                    aaid: aaid,
                    name: nameAll,
                    km: dis,
                    type: type,
                    dateE: datee,
                    dateS: dates,
                    img: img,
                    price: price,
                active: active,
                  )));
    } else {
      showCustomDialogEditFailed(context);
    }
  }

  Future showCustomDialogEditFailed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('ไม่สามารถแก้ไขได้'),
            actions: [
              FlatButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                child: Text('ปิด'),
              )
            ],
          ));


  @override
  void initState() {
    // TODO: implement initState
    id = systemInstance.userId;
    print("dasd$id");
    _fileUtil.readFile().then((id) {
      this.userId = id;
      print('id tournament ${userId}');
      getData();
      // getInfo();
      // showList();
    });

    _scrollController = ScrollController();

    // check();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget _getItem(BuildContext context, int index) {
    if (index == 0) {
      return _isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 100.0,
                  color: Colors.pink,
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 170.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FunRun())),
                        },
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // add this
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.asset('assets/images/run1.jpg',
                                  // width: 300,
                                  height: 70,
                                  fit: BoxFit.fill),
                            ),
                            ListTile(
                              title: Text('Fun Run'),
                              subtitle: Text('วิ่งระยะ 3-5 กม.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 170.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Mini())),
                        },
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // add this
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.asset('assets/images/run2.jpg',
                                  // width: 300,
                                  height: 70,
                                  fit: BoxFit.fill),
                            ),
                            ListTile(
                              title: Text('Mini Marathon'),
                              subtitle: Text('วิ่งระยะ 10-11 กม.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 170.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Half())),
                        },
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // add this
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.asset('assets/images/run3.jpg',
                                  // width: 300,
                                  height: 70,
                                  fit: BoxFit.fill),
                            ),
                            ListTile(
                              title: Text('Half Marathon'),
                              subtitle: Text('วิ่งระยะ 20-21 กม.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 170.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullMarathon())),
                        },
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // add this
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.asset('assets/images/run4.jpg',
                                  // width: 300,
                                  height: 70,
                                  fit: BoxFit.fill),
                            ),
                            ListTile(
                              title: Text('Marathon'),
                              subtitle: Text('วิ่งระยะ 42 กม.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    } else {
      return Card(
        child: Column(
          children: [
            Container(
              child: _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Loading(
                          indicator: BallPulseIndicator(),
                          size: 100.0,
                          color: Colors.pink,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () {
                                aaid = myList[index].id;
                                nameAll = myList[index].nameAll;
                                dis = myList[index].distance;
                                type = myList[index].type;
                                dates = myList[index].dateStart;
                                datee = myList[index].dateEnd;
                                img = myList[index].imgAll;
                                price = myList[index].price;
                                accessories = myList[index].accessories;
                                active = myList[index].active;
                                print(aaid);
                                print(nameAll);
                                print(dis);
                                print(type);
                                print(dates);
                                print(datee);

                                if (stat == "Admin") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EditDataScreen(
                                                aaid: aaid,
                                                name: nameAll,
                                                km: dis,
                                                type: type,
                                                dateE: datee,
                                                dateS: dates,
                                                img: img,
                                                acces: accessories,
                                                price: price,
                                                active: active,
                                              )));
                                } else {
                                  checker();
                                  // Navigator.of(context).pop();
                                }

                                // Navigator.push(context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             RegisterRun(aaid: aaid,)));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
                                      image: NetworkImage(
                                        '${Config.API_URL}/test_all/image?imgAll=${myList[index].imgAll}',
                                        headers: {
                                          "Authorization":
                                              "Bearer ${_systemInstance.token}"
                                        },
                                      ),
                                      width: 350,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("รายการ " +
                                        myList[index].nameAll.toString() +
                                        " ระยะทาง " +
                                        myList[index].distance +
                                        " กม. (ค่าสมัคร  " +
                                        myList[index].price +
                                        ".-)"),
                                    subtitle: Text(' จากวันที่ ' +
                                        myList[index].dateStart +
                                        ' ถึงวันที่ ' +
                                        myList[index].dateEnd),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _list.contains(myList[index].id) == true
                              ? Container(
                                  width: 70,
                                  height: 30,
                                  color: Colors.blue,
                                  child: Text(
                                    "สมัครแล้ว",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.zero,
                                )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //var g = _data.userId;
    //_data.user_id = 0;
    //var w = geek.geek_name = "chang";
    //_data.userId = 5;
    // print(_data.userId);
    //print(_id);

    print("gg$gg");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการวิ่ง'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        actions: [
          IconButton(
           icon: Icon(Icons.history),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OldListScreen()));
          }),
          IconButton(
              icon: Icon(Icons.playlist_add),
              onPressed: () {

                if (stat == "Admin") {
                  if(allow == "allow"){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddTournament()));
                  }else{
                    showCustomDialogNotAllow(context);
                  }

                } else {
                  showCustomDialog(context);
                }
              }),

        ],
      ),
      body: ListView.builder(
        itemCount: myList.length,
        itemBuilder: _getItem,
      ),

      // Column(
      //       children: [
      //         Container(
      //           margin: EdgeInsets.symmetric(vertical: 20.0),
      //           height: 150,
      //           child: ListView(
      //             scrollDirection: Axis.horizontal,
      //             children: [
      //               Container(
      //                 width: 170.0,
      //                 child: Card(
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                           child: InkWell(
      //                             onTap: () => {
      //                               Navigator.push(context,
      //                                   MaterialPageRoute(builder: (context) => FunRun())),
      //                             },
      //                             child: Column(
      //                               crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
      //                               children: <Widget>[
      //                                 ClipRRect(
      //                                   borderRadius: BorderRadius.only(
      //                                     topLeft: Radius.circular(8.0),
      //                                     topRight: Radius.circular(8.0),
      //                                   ),
      //                                   child: Image.asset(
      //                                       'assets/images/run1.jpg',
      //                                       // width: 300,
      //                                       height: 70,
      //                                       fit:BoxFit.fill
      //
      //                                   ),
      //                                 ),
      //                                 ListTile(
      //                                   title: Text('Fun Run'),
      //                                   subtitle: Text('วิ่งระยะ 3-5 กม.'),
      //                                 ),
      //                               ],
      //                             ),
      //                 ),
      //               ),
      //               ),
      //               Container(
      //                 width: 170.0,
      //                 child: Card(
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                   child: InkWell(
      //                     onTap: () => {
      //                       Navigator.push(context,
      //                           MaterialPageRoute(builder: (context) => Mini())),
      //                     },
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
      //                       children: <Widget>[
      //                         ClipRRect(
      //                           borderRadius: BorderRadius.only(
      //                             topLeft: Radius.circular(8.0),
      //                             topRight: Radius.circular(8.0),
      //                           ),
      //                           child: Image.asset(
      //                               'assets/images/run2.jpg',
      //                               // width: 300,
      //                               height: 70,
      //                               fit:BoxFit.fill
      //
      //                           ),
      //                         ),
      //                         ListTile(
      //                           title: Text('Mini Marathon'),
      //                           subtitle: Text('วิ่งระยะ 10-11 กม.'),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 width: 170.0,
      //                 child: Card(
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                   child: InkWell(
      //                     onTap: () => {
      //                       Navigator.push(context,
      //                           MaterialPageRoute(builder: (context) => Half())),
      //                     },
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
      //                       children: <Widget>[
      //                         ClipRRect(
      //                           borderRadius: BorderRadius.only(
      //                             topLeft: Radius.circular(8.0),
      //                             topRight: Radius.circular(8.0),
      //                           ),
      //                           child: Image.asset(
      //                               'assets/images/run3.jpg',
      //                               // width: 300,
      //                               height: 70,
      //                               fit:BoxFit.fill
      //
      //                           ),
      //                         ),
      //                         ListTile(
      //                           title: Text('Half Marathon'),
      //                           subtitle: Text('วิ่งระยะ 20-21 กม.'),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 width: 170.0,
      //                 child: Card(
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                   child: InkWell(
      //                     onTap: () => {
      //                       Navigator.push(context,
      //                           MaterialPageRoute(builder: (context) => FullMarathon())),
      //                     },
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
      //                       children: <Widget>[
      //                         ClipRRect(
      //                           borderRadius: BorderRadius.only(
      //                             topLeft: Radius.circular(8.0),
      //                             topRight: Radius.circular(8.0),
      //                           ),
      //                           child: Image.asset(
      //                               'assets/images/run4.jpg',
      //                               // width: 300,
      //                               height: 70,
      //                               fit:BoxFit.fill
      //
      //                           ),
      //                         ),
      //                         ListTile(
      //                           title: Text('Marathon'),
      //                           subtitle: Text('วิ่งระยะ 42 กม.'),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Expanded(
      //           child: Container(
      //             child: _isLoading ? Center(
      //               child: Padding(
      //                 padding: EdgeInsets.all(0),
      //                 child: Loading(
      //                   indicator: BallPulseIndicator(),
      //                   size: 100.0,
      //                   color: Colors.pink,
      //                 ),
      //               ),
      //             ):ListView.builder(
      //                 shrinkWrap: true,
      //                 itemCount: alls.length,
      //                 itemBuilder: (BuildContext context, int index){
      //                   if(_list.length == 0){
      //                     return Container(
      //                       margin:EdgeInsets.all(8.0),
      //                       child: Stack(
      //                         alignment: Alignment.topLeft,
      //                         children: [
      //                           Card(
      //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                             child: InkWell(
      //                               onTap: () {
      //                                 aaid = alls[index].id;
      //                                 nameAll = alls[index].nameAll;
      //                                 dis = alls[index].distance;
      //                                 type = alls[index].type;
      //                                 dates = alls[index].dateStart;
      //                                 datee = alls[index].dateEnd;
      //                                 img = alls[index].imgAll;
      //                                 price = alls[index].price;
      //                                 print(aaid);
      //                                 print(nameAll);
      //                                 print(dis);
      //                                 print(type);
      //                                 print(dates);
      //                                 print(datee);
      //                                 if(stat == "Admin"){
      //                                   Navigator.push(context,
      //                                       MaterialPageRoute(
      //                                           builder: (BuildContext context) =>
      //                                               EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
      //                                 }else{
      //                                   checker();
      //                                   // Navigator.of(context).pop();
      //                                 }
      //                                 // Navigator.push(context,
      //                                 //     MaterialPageRoute(
      //                                 //         builder: (BuildContext context) =>
      //                                 //             RegisterRun(aaid: aaid,)));
      //                               },
      //                               child: Column(
      //                                 children: [
      //                                   ClipRRect(
      //                                     borderRadius: BorderRadius.only(
      //                                       topLeft: Radius.circular(8.0),
      //                                       topRight: Radius.circular(8.0),
      //                                     ),
      //                                     child: FadeInImage(
      //                                       placeholder: AssetImage('assets/images/loading.gif'),
      //                                       image: NetworkImage(
      //                                         '${Config.API_URL}/test_all/image?imgAll=${alls[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
      //                                       ),
      //                                       width: 350,
      //                                       height: 150,
      //                                       fit: BoxFit.cover,
      //                                     ),
      //                                   ),
      //                                   ListTile(
      //                                     title: Text("รายการ "+alls[index].nameAll +" ระยะทาง "+ alls[index].distance +"กม. (ค่าสมัคร "+alls[index].price+".-)"),
      //                                     subtitle: Text(' จากวันที่ ' + alls[index].dateStart + ' ถึงวันที่ '
      //                                         + alls[index].dateEnd),
      //
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   }else{
      //                     return Container(
      //                       margin:EdgeInsets.all(8.0),
      //                       child: Stack(
      //                         alignment: Alignment.topLeft,
      //                         children: [
      //                           Card(
      //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //                             child: InkWell(
      //                               onTap: () {
      //                                 aaid = alls[index].id;
      //                                 nameAll = alls[index].nameAll;
      //                                 dis = alls[index].distance;
      //                                 type = alls[index].type;
      //                                 dates = alls[index].dateStart;
      //                                 datee = alls[index].dateEnd;
      //                                 img = alls[index].imgAll;
      //                                 price = alls[index].price;
      //                                 print(aaid);
      //                                 print(nameAll);
      //                                 print(dis);
      //                                 print(type);
      //                                 print(dates);
      //                                 print(datee);
      //                                 if(stat == "Admin"){
      //                                   Navigator.push(context,
      //                                       MaterialPageRoute(
      //                                           builder: (BuildContext context) =>
      //                                               EditDataScreen(aaid: aaid,name: nameAll,km: dis,type: type,dateE: datee,dateS: dates,img: img,price: price,)));
      //                                 }else{
      //                                   checker();
      //                                   // Navigator.of(context).pop();
      //                                 }
      //                                 // Navigator.push(context,
      //                                 //     MaterialPageRoute(
      //                                 //         builder: (BuildContext context) =>
      //                                 //             RegisterRun(aaid: aaid,)));
      //                               },
      //                               child: Column(
      //                                 children: [
      //                                   ClipRRect(
      //                                     borderRadius: BorderRadius.only(
      //                                       topLeft: Radius.circular(8.0),
      //                                       topRight: Radius.circular(8.0),
      //                                     ),
      //                                     child: FadeInImage(
      //                                       placeholder: AssetImage('assets/images/loading.gif'),
      //                                       image: NetworkImage(
      //                                         '${Config.API_URL}/test_all/image?imgAll=${alls[index].imgAll}',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
      //                                       ),
      //                                       width: 350,
      //                                       height: 150,
      //                                       fit: BoxFit.cover,
      //                                     ),
      //                                   ),
      //                                   ListTile(
      //                                     title: Text("รายการ "+alls[index].nameAll +" ระยะทาง "+ alls[index].distance+" กม. (ค่าสมัคร  "+alls[index].price+".-)"),
      //                                     subtitle: Text(' จากวันที่ ' + alls[index].dateStart + ' ถึงวันที่ '
      //                                         + alls[index].dateEnd),
      //
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //
      //                           ),
      //                           _list.contains(alls[index].id) == true ? Container(
      //                             width: 70,
      //                             height: 30,
      //                             color: Colors.blue,
      //                             child: Text("สมัครแล้ว",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
      //                           ):Padding(padding: EdgeInsets.zero,)
      //                         ],
      //                       ),
      //                     );
      //                   }
      //                 }
      //                 ),
      //           ),
      //         ),
      //       ]
      // )
    );
  }
}

class AllRunner {
  final int id;
  final int userId;
  final String nameAll;
  final String distance;
  final String type;
  final String dateStart;
  final String dateEnd;
  final String imgAll;
  final String price;
  final String accessories;
  final String active;
  final String createDate;

  AllRunner(this.id, this.userId, this.nameAll, this.distance, this.type,
      this.dateStart, this.dateEnd, this.imgAll, this.price, this.accessories,this.active,this.createDate);
}

class MyRunner {
  final int rid;
  final int userId;
  final int id;
  final String size;
  final String createDate;
  final String status;
  final String imgSlip;
  final String isRegister;

  MyRunner(this.rid, this.userId, this.id, this.size, this.createDate,
      this.status, this.imgSlip, this.isRegister);
}
