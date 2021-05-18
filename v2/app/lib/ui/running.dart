import 'dart:async';
import 'dart:math';

import 'package:app/run/startrun.dart';
import 'package:app/system/SystemInstance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Running extends StatefulWidget {
  static const routeName = '/running';
  final int idrunner;
  final String isType;

  const Running({Key key, this.idrunner, this.isType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RunningState();
  }
}

class _RunningState extends State<Running> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  double lat = 16.4329112;
  double lng = 102.823361;
  SystemInstance _systemInstance = SystemInstance();
  int theId;
  var theType;
  var allRunId;

  @override
  Widget build(BuildContext context) {
    theType = widget.isType;
    allRunId = widget.idrunner;
    print(allRunId);
    print(theType);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('วิ่ง'),
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 580,
                width: 300,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(320, 10, 10, 10),
              //   child: FloatingActionButton.extended(
              //       onPressed: _goTome,
              //        label: Text(''),
              //       icon: Icon(Icons.gps_fixed)
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('เริ่มวิ่ง'),
                    onPressed: () {
                      print("ID:${theId}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartRun(
                                    myType: theType,
                                    startId: allRunId,
                                  )));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}

      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
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
