import 'dart:convert';
import 'dart:math';

import 'package:app/config/config.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  SystemInstance _systemInstance = SystemInstance();
  double km;
  double m;

  var locationMassage = "";
  var distanceMessage = "";

  Location _location = Location();

  LocationData _locationData = null;

  String _lng = "";
  String _lat = "";

  var resLat;
  String resLng;
  List _list = new List();
  List _listSum = List();

  Map map = {};
  Map sum = {};
  Map _sum = {};
  int a = 0;
  int b = 0;
  List<locat> lo = List();

  @override
  void initState() {
    // TODO: implement initState
    calculate();
    _location.onLocationChanged.listen((locationData) {
      String lng = "${locationData.longitude}";
      String lat = "${locationData.latitude}";
      if (lng != _lng && lat != _lat) {
        print("on location change...");
        print("data lat ${locationData.latitude} .....");
        print("data lng ${locationData.longitude} .....");

        _lng = lng;
        _lat = lat;
        // Map params = Map();
        // params['lat'] = lat.toString();
        // params['lng'] = lng.toString();
        // Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
        // http.post('${Config.API_URL}/test_save_latlng/save',headers: header, body: params).then((res) {
        //   Map resMap = jsonDecode(res.body) as Map;
        //   print(resMap);
        // });
      }
    });
    super.initState();
  }

//----------------------------------------------------------------------------------------------------------------

  void getCurrentLocation() async {
    // var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // var lastPosition = await Geolocator().getLastKnownPosition();
    // print('asa${lastPosition}');
    // var current = lastPosition;
    // var lat = position.latitude;
    // var long = position.longitude;
    // var lati = _lat;
    // var long = _lng;
    // print('Lati${lati}');
    // print('Longi${long}');
    // setState(() {
    //   locationMassage = "Latitude:$lati, Longitude:$long";
    // });
  }

//--------------------------------------------------------------------------------------------

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var total = 12742 * asin(sqrt(a));
    return total;
  }

  void calculate() {
    Map params = Map();
    Map<String, String> header = {
      "Authorization": "Bearer ${_systemInstance.token}"
    };
    http
        .post('${Config.API_URL}/test_save_latlng/load',
            headers: header, body: params)
        .then((res) {
      print("xxx");
      Map resMap = jsonDecode(res.body) as Map;
      print('resMap:  ${resMap}');
      var data = resMap['data'];
      print('data:   ${data}');
      for (var i in data) {
        // print('i: ${i}');
        var lat = i['lat'];
        var lng = i['lng'];
        map = {'lat': lat, 'lng': lng};
        _listSum.add(map);
      }

      print(_listSum);
      print(_listSum.runtimeType);

      double totalDistance = 0;
      for (var i = 0; i < _listSum.length - 1; i++) {
        totalDistance += calculateDistance(_listSum[i]["lat"],
            _listSum[i]["lng"], _listSum[i + 1]["lat"], _listSum[i + 1]["lng"]);
      }
      distanceMessage = totalDistance.toStringAsFixed(2);
      print('${distanceMessage}Km');
      setState(() {});
    });
    // print('xf: ${_listSum}');
    // List<dynamic> data = _listSum;
    // double totalDistance = 0;
    // for (var i = 0; i < data.length - 1; i++) {
    //   totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
    //       data[i + 1]["lat"], data[i + 1]["lng"]);
    // }
    // distanceMessage = totalDistance.toStringAsFixed(2);
    // print('${distanceMessage}Km');
  }

  //----------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _listSum = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 46.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Get Location',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('Latitude: ${_lat} Longitude: ${_lng}'),
            Text(locationMassage),
            Text('${distanceMessage} Km'),
            // FlatButton(onPressed: (){
            //   getCurrentLocation();
            //   },
            //   color: Colors.blue[800],
            //   child: Text('Get current',style: TextStyle(color: Colors.white),),
            // ),
            FlatButton(
              onPressed: () {
                //getData();
              },
              color: Colors.blue[800],
              child: Text(
                'คำนวน',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class locat {
  final int id;
  final double lat;
  final double lng;

  locat(this.id, this.lat, this.lng);
}
