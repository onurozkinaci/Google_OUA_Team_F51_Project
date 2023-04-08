import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/constants.dart';
import 'package:flutter_appjamproject/pages/greeting_page.dart';
import 'package:flutter_appjamproject/pages/note_list_page.dart';
import 'package:flutter_appjamproject/pages/note_type_selection.dart';
import '../widgets/specializedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, GreetingPage.id);
            }),
        title: Text('Login Page'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 120.0,
                  child: Image.asset('images/notepad_image.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),

            //=>'constants' dosyasinda tutulan kTextFieldDecoration degiskeni kullanilip, orada tutulan hintText degeri
            //copyWith icerisinde farkli bir sekilde iletilerek, diger tum ozellikler o degisken ile ayni alinip hintText farkli kullanilacak
            //sekilde islem saglandi.
            TextField(
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Please enter your email...'),
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText:
                  true, //girilen input'u password gibiyse sifrelemek (encrpytion) icin
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Please enter your password...'),
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 42.0,
                width: 200.0,
                child: SpecializedButton(
                    title: 'LOGIN',
                    color: Colors.lightBlue[900],
                    onPressedFunc: () async {
                      try {
                        final loggedInUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (loggedInUser != null) {
                          //=>Alert message gibi bir 'Toast message' verilerek, diger sayfaya gecilmeden once kullanicinin basarili bir sekilde uygulamaya
                          // giris yapabildiginin bilgisi verilecektir;
                          Fluttertoast.showToast(
                              msg: "Welcome, the login is successful!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pushNamed(
                              context, NoteTypeSelectionPage.id);
                          //=>Basarili bir sekilde login olan kullanici, kendi notlarini veya grup arkadaslarinin notlarini gormek icin secim yapacagi
                          //NoteTypeSelectionPage sayfasina yonlendirilecek.
                        }
                      } catch (exception) {
                        print(exception);
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
