import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/pages/greeting_page.dart';
import 'package:flutter_appjamproject/pages/note_list_page.dart';
import 'package:flutter_appjamproject/pages/note_slide_page.dart';
import 'package:flutter_appjamproject/pages/note_type_selection.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InfoCardApp());
}

class InfoCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: GreetingPage.id,
      /**Bu sekilde routelari belirterek her class'ta static olarak tanimlanmis olan
      //id degiskenleri uzerinden nesne olusturmaya gerek olmadan direkt yonlendirme
      //icin bu degisken uzerinden cagrim yapilabilecek ve her birinin karsiladigi
      //route da asagidaki gibidir;
      */
      routes: {
        GreetingPage.id: (context) => GreetingPage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        NoteListPage.id: (context) => NoteListPage(),
        NoteSlidePage.id: (context) => NoteSlidePage(),
        NoteTypeSelectionPage.id: (context) => NoteTypeSelectionPage(),
      },
    );
  }
}
