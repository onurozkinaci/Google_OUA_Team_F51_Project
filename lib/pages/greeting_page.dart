import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/widgets/specializedButton.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class GreetingPage extends StatefulWidget {
  static const String id = 'greeting_page';
  @override
  _GreetingPageState createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Hero widget'inda belirtilen tag ile ayni tag'i tutan ve ayni image'i tutan Login Page ve Register Pagelere gecis yapildiginda,
                //burada tutulan image icin bir gecis gorunumu/animasyon verilir.
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/notepad_image.png'),
                    height: 120.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            SpecializedButton(
                title: 'LOGIN',
                color: Colors.lightBlue[900],
                onPressedFunc: () {
                  Navigator.pushNamed(context, LoginPage.id);
                }),
            SpecializedButton(
                title: 'REGISTER',
                color: Colors.lightBlue[900],
                onPressedFunc: () {
                  Navigator.pushNamed(context, RegisterPage.id);
                }),
          ],
        ),
      ),
    );
  }
}
