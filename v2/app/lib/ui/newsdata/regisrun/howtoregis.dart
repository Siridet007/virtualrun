import 'package:app/util/utils.dart';
import 'package:app/widget/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../intro.dart';

class HowToRegister extends StatefulWidget {
  @override
  _HowToRegisterState createState() => _HowToRegisterState();
}

class _HowToRegisterState extends State<HowToRegister> {
  final _controller = PageController();
  bool leadingVisibility = false;
  Screen  size;
  Color colorCurve = Color.fromRGBO(97, 10, 165, 0.8);

  final List<Widget> _pages = [
    IntroPage("assets/images/howuser1.jpg","", "เมื่อ Login เข้ามาจะพบกับหน้ารายการวิ่ง \n \n เลือกประเภทที่ต้องการสมัคร"),
    IntroPage("assets/images/howuser2.jpg","", "จะเห็นรายการในประเภทนั้น ๆ  \n \n เลือกรายการที่ต้องการสมัคร"),
    IntroPage("assets/images/howuser3.jpg","", "เมื่อเลือกเสร็จแล้วจะมีแจ้งเตือนขึ้นมา \n \n เริ่มวิ่งได้เลย"),
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
