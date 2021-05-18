import 'package:flutter/material.dart';
import 'dart:math';

import 'package:latlong/latlong.dart';

class CalDistance extends StatefulWidget {
  @override
  _CalDistanceState createState() => _CalDistanceState();
}

class _CalDistanceState extends State<CalDistance> {
  var km;
  var m;

  void Calculate() {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p)) / 2;
      var total = 12742 * asin(sqrt(a));
      print('hee${total}');
      return total;
    }

    List<dynamic> data = [
      // {
      //   "lat": 44.968046,
      //   "lng": -94.420307
      // }, {
      //   "lat": 44.33328,
      //   "lng": -89.132008
      // }, {
      //   "lat": 33.755787,
      //   "lng": -116.359998
      // }, {
      //   "lat": 33.844843,
      //   "lng": -116.54911
      // }, {
      //   "lat": 44.92057,
      //   "lng": -93.44786
      // }, {
      //   "lat": 44.240309,
      //   "lng": -91.493619
      // }, {
      //   "lat": 44.968041,
      //   "lng": -94.419696
      // }, {
      //   "lat": 44.333304,
      //   "lng": -89.132027
      // }, {
      //   "lat": 33.755783,
      //   "lng": -116.360066
      // }, {
      //   "lat": 33.844847,
      //   "lng": -116.549069
      // },
      {
        "lat": 16.4334117,
        "lng": 102.858365
      },
      {
        "lat": 16.43246,
        "lng": 102.8249483
      },
    ];
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += calculateDistance(
          data[i]["lat"], data[i]["lng"], data[i + 1]["lat"],
          data[i + 1]["lng"]);
    }
    print('hum${totalDistance}');

    final Distance distance = Distance();
    double totalDistanceInM = 0;
    double totalDistanceInKm = 0;

    for(var i = 0; i < data.length - 1; i++){
      //Calculate Km
      totalDistanceInM += distance(
          LatLng(data[i]["lat"], data[i]["lng"]),
          LatLng(data[i+1]["lat"], data[i+1]["lng"])
      );
      //Calculate Km
      totalDistanceInKm += distance.as(
        LengthUnit.Kilometer,
        LatLng(data[i]["lat"], data[i]["lng"]),
        LatLng(data[i+1]["lat"], data[i+1]["lng"]),
      );
    }
    print('${totalDistanceInM}M');
    print('${totalDistanceInKm}km');
    m = totalDistanceInM;
    km = totalDistanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('cal'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${m} M'),
            Text('${km} Km'),
            FlatButton(
              onPressed: (){
                Calculate();
              },
              color: Colors.blue[800],
              child: Text('Go',style: TextStyle(color: Colors.white),),
            ),

          ],
        ),
      ),
    );
  }
}
