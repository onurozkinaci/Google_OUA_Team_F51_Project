import 'package:flutter/material.dart';
//Burada tanimlanan constant degisikenler ihtiyac duyuldugu yerlerde, ilgili classlarda cagrilarak kod tekrarinin onune gecilmesini ve ortak
//kullanilan sabit degerlerin birden cok yerde kullanilabilmesini saglarlar ('reusability').

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter an input',
  //hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
