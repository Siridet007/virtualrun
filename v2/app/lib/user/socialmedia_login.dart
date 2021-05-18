import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SocailMediaLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SocialMediaLogin();
  }
}

class _SocialMediaLogin extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text('เข้าสู้ระบบโดย'),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: SignInButton(Buttons.Facebook, onPressed: () {})),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SignInButton(
                Buttons.AppleDark,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
