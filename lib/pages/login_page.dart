import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/constants.dart';
import 'package:flutter_appjamproject/pages/note_list_page.dart';
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
        title: Text('Login Page'),
        backgroundColor: Colors.lightBlueAccent,
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
                    color: Colors.lightBlueAccent,
                    onPressedFunc: () async {
                      try {
                        final loggedInUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (loggedInUser != null) {
                          //=>Alert message gibi bir 'Toast message' verilerek, diger sayfaya gecilmeden once kullanicinin basarili bir sekilde uygulamaya
                          // giris yapabildiginin bilgisi verilecektir;
                          Fluttertoast.showToast(
                              msg: "Welcome, the user has logined succesfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pushNamed(context, NoteListPage.id);
                          /*TODO:eklenince notlarin old. sayfaya gidecek, orada yine FirebaseAuth yapisini kullanarak current user'in(login) olan kim old.
                                 bilgisine erisebilirsin (FirebaseAuth.instance.currentUser gibi bir kullanimla erisebilirsin).
                          */
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
