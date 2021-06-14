import 'dart:convert';
import 'dart:io';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var userId;
  var passWord;
  var au;
  File _image;
  var userName;
  var myName;
  var myTel;
  var myImg;
  SystemInstance systemInstance = SystemInstance();
  SystemInstance _systemInstance = SystemInstance();
  TextEditingController name = TextEditingController();
  TextEditingController tel = TextEditingController();
  final picker = ImagePicker();
  var pickedFile;
  var allow;

  Future getImage() async{
    pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
    // File image = await ImagePicker.pickImage(source: source);
    // if(image != null){
    //   File cropper = await ImageCropper.cropImage(
    //     sourcePath: image.path,
    //     aspectRatio: CropAspectRatio(
    //       ratioX: 1,ratioY: 1,
    //     ),
    //     compressQuality: 100,
    //     maxWidth: 700,
    //     maxHeight: 700,
    //     compressFormat: ImageCompressFormat.png,
    //     androidUiSettings: AndroidUiSettings(
    //
    //       toolbarColor: Colors.deepOrange,
    //       toolbarTitle: "Cropper",
    //       statusBarColor: Colors.deepOrange.shade900,
    //       backgroundColor: Colors.white,
    //     ),
    //   );
    //   this.setState(() {
    //     _image = cropper;
    //   });
    // }
  }

  Future getData()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for (var i in sum){
      passWord = i['passWord'];
      userName = i['userName'];
      au = i['au'];
      allow = i['autho'];
      // myName = i['name'];
      // myTel = ['tel'];
      // myImg = ['imgProfile'];
    }
    setState(() {

    });
  }
  Future getDataName()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for (var i in sum){
      myName = i['name'];
    }
    setState(() {

    });
    print("myName $myName");
    return myName;
  }
  Future getDataTel()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for (var i in sum){
      myTel = i['tel'];
    }
    setState(() {

    });
    print("myTel $myTel");
    return myTel;
  }
  Future getDataImg()async{
    Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
    var data = await http.post('${Config.API_URL}/user_profile/show?userId=$userId',headers: header);
    var _data = jsonDecode(data.body);
    var sum = _data['data'];
    print(sum);
    for (var i in sum){
      myImg = i['imgProfile'];
    }
    setState(() {

    });
    print("myImg $myImg");
    return myImg;
  }
  Future showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('บันทึกสำเร็จ'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด'),
          )
        ],
      )
  );

  void onClick(){
    print(userId);
    print(passWord);
    print(au);
    print(userName);
    print(name);
    print(tel);
    var isName;
    var isTel;
    if(name.text.isEmpty){
      isName = myName;
    }else{
      isName = name.text;
    }
    if(tel.text.isEmpty){
      isTel = myTel;
    }else{
      isTel = tel.text;
    }
    Dio dio = Dio();
    Dio dios = Dio();
    Map<String, dynamic> params = Map();
    Map<String,dynamic> par = Map();
    params['userId'] = userId;
    params['userName'] = userName.toString();
    params['passWord'] = passWord.toString();
    params['name'] = isName.toString();
    params['tel'] = isTel.toString();
    params['au'] = au.toString();
    params['autho'] = allow.toString();
    params['fileImg'] = MultipartFile.fromBytes(_image.readAsBytesSync(), filename: "filename.png");
    par['fileImg'] = MultipartFile.fromBytes(_image.readAsBytesSync(), filename: "filename.png");
    FormData formData = FormData.fromMap(params);
    FormData formDatas = FormData.fromMap(par);
    dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}";
    dios.options.headers["Authorization"] = "Bearer ${_systemInstance.token}";
    print("adsad${dio.options.headers["Authorization"] = "Bearer ${_systemInstance.token}"}");
    dio.post('${Config.API_URL}/user_profile/update_profile',data: formData).then((res) {
      Map resMap = jsonDecode(res.toString()) as Map;
      print("save");
      var data = resMap['status'];
      if(data == 1){
        showCustomDialog(context);
        Navigator.pop(context);
      }else{
        CoolAlert.show(context: context, type: CoolAlertType.error, text: 'ทำรายการไม่สำเร็จ');
      }

    });
    // dios.post('${Config.API_URL}/ranking/update',data: formDatas).then((res) {
    //   Map resMap = jsonDecode(res.toString()) as Map;
    //   print("save");
    //   var data = resMap['status'];
    //   if(data == 1){
    //     showCustomDialog(context);
    //     setState(() {});
    //   }else{
    //     CoolAlert.show(context: context, type: CoolAlertType.error, text: 'ทำรายการไม่สำเร็จ');
    //   }
    //
    // });
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    userId = systemInstance.userId;

    getData();
    getDataName();
    getDataTel();
    getDataImg();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ตั้งค่าโปรไฟล์",),
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
      body: ListView(
        children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'แก้ไขโปรไฟล์',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text('ชื่อโปรไฟล์',style: TextStyle(color: Colors.black),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'ชื่อโปรไฟล์',
                      hintText: myName,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text('เบอร์โทรศัพท์',style: TextStyle(color: Colors.black),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    controller: tel,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'เบอร์โทรศัพท์',
                      hintText: myTel,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: _image == null ? Container(
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/loading.gif'),
                          image: NetworkImage(
                            '${Config.API_URL}/user_profile/image?imgProfile=$myImg',headers: {"Authorization": "Bearer ${_systemInstance.token}"},
                          ),
                          width: 250.0 ,
                          height: 250.0,
                        ),
                    ):Image.file(_image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 20, 100, 10),
                  child: Container(
                    child: RaisedButton.icon(
                      label: Text('เปลี่ยนรูปภาพ'),
                      icon: Icon(Icons.add_a_photo),
                      onPressed: (){
                        getImage();
                      },
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('บันทึก'),
                    onPressed: () {
                      // if(name.text.isNotEmpty && tel.text.isNotEmpty){
                        onClick();
                      // }else{
                      //   CoolAlert.show(context: context, type: CoolAlertType.warning, text: 'กรุณากรอกข้อมูลให้ครบถ้วน');
                      // }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
