import 'package:flutter/material.dart';

import 'package:app/ui/rundata/datafull.dart';
import 'package:app/ui/rundata/datafun.dart';
import 'package:app/ui/rundata/datahalf.dart';
import 'package:app/ui/rundata/datamini.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('ตารางอันดับ'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(child:Text('Fun Run'),),
                Tab(child:Text('Mini'),),
                Tab(child:Text('Half'),),
                Tab(child:Text('Full'),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DataFun(),
              DataMini(),
              DataHalf(),
              DataFull(),
            ],
          ),
        ),
      ),
    );
  }
}
