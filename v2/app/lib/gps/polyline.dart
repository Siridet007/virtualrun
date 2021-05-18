import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class Polyline extends StatefulWidget {
  @override
  _PolylineState createState() => _PolylineState();
}

class _PolylineState extends State<Polyline> {

  // void loadToPolyline(){
  //   Map params = Map();
  //   Map<String, String> header = {"Authorization": "Bearer ${_systemInstance.token}"};
  //   http.post('${Config.API_URL}/save_runner/load', headers: header,body: params).then((res) {
  //     print("xxx");
  //     Map resMap = jsonDecode(res.body) as Map;
  //     print('resMap:  ${resMap}');
  //     var data = resMap['data'];
  //     print('data:   ${data}');
  //     for (var i in data) {
  //       print('i: ${i}');
  //       var lat = i['lat'];
  //       var lng = i['lng'];
  //       print("lat${lat}");
  //       print("lat${lng}");
  //     }
  //     setState(() {
  //     });
  //   });
  // }
  // List<double> _list = [];
  // var point = <LatLng>[
  //   LatLng(16.4464643,102.8492125),
  //   LatLng(16.4467942,102.8494465),
  //   LatLng(16.4472939,102.8496678),
  //   LatLng(16.4475511,102.8497208),
  //   LatLng(16.4479724,102.8497248),
  //   LatLng(16.4484631,102.8496376),
  //   LatLng(16.4489853,102.8494184),
  //   LatLng(16.4493364,102.8494921),
  //   LatLng(16.4511137,102.848984),
  //   LatLng(16.4516719,102.8491409),
  //   LatLng(16.4518861,102.8496344),
  //   LatLng(16.4519758,102.8535971),
  //   LatLng(16.4514739,102.8547799),
  //   LatLng(16.4509434,102.8551825),
  //   LatLng(16.4501508,102.8550715),
  //   LatLng(16.4497263,102.8544097),
  //   LatLng(16.4452104,102.8520371),
  //   LatLng(16.4464643,102.8492125),
  // ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Maps'),),
      body: new FlutterMap(
        options: new MapOptions(
        ),
      ),
    );
  }


}
