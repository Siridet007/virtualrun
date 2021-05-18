import 'package:app/util/responsive_screen.dart';
import 'package:app/widget/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../intro.dart';

class HowToRunScreen extends StatefulWidget {
  @override
  _HowToRunScreenState createState() => _HowToRunScreenState();
}

class _HowToRunScreenState extends State<HowToRunScreen> {

  final _controller = PageController();
  bool leadingVisibility = false;
  Screen  size;
  Color colorCurve = Color.fromRGBO(97, 10, 165, 0.8);

  final List<Widget> _pages = [
    IntroPage("assets/images/howrun1.jpg","", "เมื่อกดที่หน้ารายการที่ลงทะเบียนไว้ \n \n จะเห็นรายการต่าง ๆ ที่เราได้สมัครไว้ แล้วเลือกรายการที่จะวิ่ง"),
    IntroPage("assets/images/howrun2.jpg","", "จะเห็นหน้าบอกระยะทางทั้งหมด และระยะทางที่วิ่งไปแล้ว \n \n กดต่อไปเลย"),
    IntroPage("assets/images/howrun3.jpg","", "จะเห็นตำแหน่งของตนเองในหน้าจอ \n \n กดต่อไปเลย"),
    IntroPage("assets/images/howrun4.jpg","", "เมื่อกดเริ่มวิ่งจะมาที่หน้าเริ่ม ให้กดปุ่ม play แล้วเริ่มวิ่งได้เลย\n \n เมื่อต้องการพักให้กดปุ่ม pause "),
    IntroPage("assets/images/howrun5.jpg","", "เมื่อกดปุ่ม pause แล้วจะมาที่หน้า พัก จะบอกตำแหน่ง กิโลเมตรที่ทำได้ แคลลอรี่ที่ทำได้ และเวลาที่ทำได้\n \n ถ้าต้องการหยุดวิ่งให้กดที่ปุ่ม stop "),
    IntroPage("assets/images/howrun6.jpg","", " \n \n เมื่อกดปุ่ม stop แล้ว จะมีแจ้งเตือนบอกว่าหยุดวิ่งแล้ว \n กดปิดได้เลย"),
  ];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    bool isLastPage = currentPageIndex == _pages.length - 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('วิธีใช้งาน'),
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
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          child: Stack(
            children: <Widget>[
              pageViewFillWidget(),
              appBarWithButton(isLastPage, context),
              bottomDotsWidget()
            ],
          ),
        ),
      ),
    );
  }
  Positioned bottomDotsWidget() {
    return Positioned(
        bottom: size.getWidthPx(20),
        left: 0.0,
        right: 0.0,
        child: DotsIndicator(
          controller: _controller,
          itemCount: _pages.length,
          color: colorCurve,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ));
  }

  Positioned appBarWithButton(bool isLastPage, BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: new SafeArea(
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          primary: false,
          centerTitle: true,
          leading: Visibility(
              visible: leadingVisibility,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _controller.animateToPage(currentPageIndex - 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                },
              )),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: size.getWidthPx(16), right:  size.getWidthPx(12), bottom: size.getWidthPx(12)),
              child: RaisedButton(
                child: Text(
                  isLastPage ? 'เสร็จสิ้น' : 'ต่อไป',
                  style: TextStyle(fontFamily: 'Exo2',fontWeight: FontWeight.w500,fontSize: 14,color: Colors.blue),
                ),
                onPressed: isLastPage
                    ? () async{
                  Navigator.of(context).pop();

                }
                    : () {
                  _controller.animateToPage(currentPageIndex + 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Positioned pageViewFillWidget() {
    return Positioned.fill(
        child: PageView.builder(
          controller: _controller,
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) {
            return _pages[index % _pages.length];
          },
          onPageChanged: (int p) {
            setState(() {
              currentPageIndex = p;
              if (currentPageIndex == 0) {
                leadingVisibility = false;
              } else {
                leadingVisibility = true;
              }
            });
          },
        ));
  }
}
