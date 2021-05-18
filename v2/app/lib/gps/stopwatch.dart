import 'dart:async';

import 'package:flutter/material.dart';


class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {

  bool startbutton = true;
  bool stopbutton = true;
  bool resetbutton = true;
  String timer = "00:00:00";
  var swatch = Stopwatch();

  final dur = const Duration(seconds: 1);

  void starttimer(){
    Timer(dur, keeprunning);
  }

  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
    }
    setState(() {
      timer = swatch.elapsed.inHours.toString().padLeft(2,"0")+":"+
          (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0")+":"+
          (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }
  void startstopwatch(){
    setState(() {
      stopbutton = false;
      startbutton = false;
    });
    swatch.start();
    starttimer();
  }
  void stopstopwatch(){
    setState(() {
      stopbutton = true;
      resetbutton = false;
    });
    swatch.stop();
  }
  void resetstopwatch(){
    setState(() {
      startbutton = true;
      resetbutton = true;
    });
    swatch.reset();
    timer = "00:00:00";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("stopwatch"),),
      body:Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(""
                      "${timer}",style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: (){
                        stopstopwatch();
                      },
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                      child: Text(""
                          "Stop",style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    ),
                    RaisedButton(
                      onPressed: (){
                        resetstopwatch();
                      },
                      color: Colors.teal,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                      child: Text(""
                          "Reset",style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ],
                ),

              ),
              RaisedButton(
                onPressed: (){
                  startstopwatch();
                },
                color: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: 80.0,
                  vertical: 15.0,
                ),
                child: Text(""
                    "Start",style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
