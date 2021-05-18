import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MyMapPageState();
}

class MyMapPageState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;

  var point = <LatLng>[
    LatLng(16.4464643, 102.8492125),
    LatLng(16.4467942, 102.8494465),
    LatLng(16.4472939, 102.8496678),
    LatLng(16.4475511, 102.8497208),
    LatLng(16.4479724, 102.8497248),
    LatLng(16.4484631, 102.8496376),
    LatLng(16.4489853, 102.8494184),
    LatLng(16.4493364, 102.8494921),
    LatLng(16.4511137, 102.848984),
    LatLng(16.4516719, 102.8491409),
    LatLng(16.4518861, 102.8496344),
    LatLng(16.4519758, 102.8535971),
    LatLng(16.4514739, 102.8547799),
    LatLng(16.4509434, 102.8551825),
    LatLng(16.4501508, 102.8550715),
    LatLng(16.4497263, 102.8544097),
    LatLng(16.4452104, 102.8520371),
    LatLng(16.4464643, 102.8492125),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: Center(
          child: Container(
            child: GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(16.43347, 102.858376),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                    polylineId: PolylineId("p1"),
                    color: Colors.blue,
                    points: point)
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _goTome,
            label: Text('My location'),
            icon: Icon(Icons.gps_fixed)),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      return null;
    }
  }

  Future _goTome() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 18,
        ),
      ),
    );
  }

  static double getDistanceFromGPSPointsInRoute(List<LatLng> gpsList) {
    double totalDistance = 0.0;

    for (var i = 0; i < gpsList.length; i++) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((gpsList[i + 1].latitude - gpsList[i].latitude) * p) / 2 +
          c(gpsList[i].latitude * p) *
              c(gpsList[i + 1].latitude * p) *
              (1 - c((gpsList[i + 1].longitude - gpsList[i].longitude) * p)) /
              2;
      double distance = 12742 * asin(sqrt(a));
      totalDistance += distance;
      print('Distance is ${12742 * asin(sqrt(a))}');
    }
    print('Total distance is $totalDistance');
    print('');

    return totalDistance;
  }
}

/*
class Distance extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Distance();
  }


}
class _Distance extends State{
  final Distance distance = new Distance();

  // km = 423
  final int km = distance.as(LengthUnit.Kilometer,
      new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));

  // meter = 422591.551
  final int meter = distance(
      new LatLng(52.518611,13.408056),
      new LatLng(51.519475,7.46694444)
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null();
  }

}*/
