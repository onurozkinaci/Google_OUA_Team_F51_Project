import 'package:flutter/material.dart';

//Bu class'in olusturulma amaci, reusable bir widget kullanimi saglayip birden cok yerde kullanilan ElevatedButton widget'inin kod tekrari olmadan,
//ozellestirilmis bir widget gibi kullanilabilmesini saglamaktir.
//=>Ek olarak, bu class cagrilirken constructor'da onPressedFunc ile iletilen fonksiyon, butona tiklaninca tetiklenir.
class SpecializedButton extends StatelessWidget {
  final void Function() onPressedFunc;
  final String title;
  final Color? color;

  SpecializedButton(
      {this.color, required this.title, required this.onPressedFunc});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            //to set border radius to button
            borderRadius: BorderRadius.circular(30)),
        backgroundColor: color,
      ),
      onPressed: onPressedFunc,
      child: Text(title),
    );
  }
}
