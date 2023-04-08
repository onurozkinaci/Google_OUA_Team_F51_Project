import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/pages/greeting_page.dart';
import 'package:flutter_appjamproject/pages/note_type_selection.dart';
import '../constants.dart';
import '../widgets/specializedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'register_page';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: Text('Register Page'),
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
            TextField(
              keyboardType: TextInputType.emailAddress,
              //=>klavyeyi e-mail input'u girilebilecek formata cevirir;
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
                    title: 'REGISTER',
                    color: Colors.lightBlue[900],
                    onPressedFunc: () async {
                      //Bu islem Future dondugu ve async old. icin user'in olusturulup olusturulmadigi bilgisini atandigi
                      //degisken (newUser) uzerinden kontrol edebiliriz. 'await' ve 'async' kullanimiyla bu islemin bitmesini bekleyip etkiledigi
                      //sonraki steplerin bunun tamamlanmasi ile birlikte devam edecegini belirtmis oluyoruz.
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          //=>Alert message gibi bir 'Toast message' verilerek, diger sayfaya gecilmeden once kullanicinin Firebase'e register edildiginin
                          //bilgisi verilecektir;
                          Fluttertoast.showToast(
                              msg: "The user is registered succesfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pushNamed(
                              context, NoteTypeSelectionPage.id);
                          //=>Basarili bir sekilde uygulamaya kaydolan/register kullanici, kendi notlarini veya grup arkadaslarinin notlarini gormek icin secim yapacagi
                          //NoteTypeSelectionPage sayfasina yonlendirilecek.
                        }
                      } catch (error) {
                        print(error);
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
