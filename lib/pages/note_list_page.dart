import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appjamproject/pages/login_page.dart';
import 'package:flutter_appjamproject/pages/note_type_selection.dart';
import 'note_slide_page.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class NoteListPage extends StatefulWidget {
  static const String id = 'note_list_page';

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final _auth = FirebaseAuth.instance;

  //=>State objesi olustugunda bir kez tetiklenir ve burada login olan kullanicinin bilgisini alip eklenen notlari onun maili uzerinden
  //Firebase Firestore'a gondererek login olan kullaniciya ozgu kilmis oluyoruz;
  @override
  initState() {
    super.initState();
    getLoggedInUser();
  }

  //Login olan kullanici bilgisini getirmek icin;
  void getLoggedInUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  ///**=>Firebase Firestore'da login olan kullanicinin kaydettigi notlari (maili uzerinden) getirmek icin;
  ///=>'Stream' kullanimiyla, ornegin bir notun trash icon'a tiklanip silinmesi gibi durumlarda Firebase Firestore'da
  /// degisiklik oldugundan, bu degisikligin tekrar metodu cagirmaya gerek olmadan Firestore'daki guncellenmis(degisen)
  /// verileri ekranimiza yansitmayi sagladik;
  /// --------------------------------------------------
  ///=>'Subscribe' olunan stream'deki(notes collection stream'i) degisiklikler dinlenir (listen) ve bu stream'de degisiklik
  /// oldugunda(Firestore'da bu collection'a veri eklenmesi,cikarilmasi,guncellenmesi,vb.) bilgilendirme(notify) saglanip
  /// bu stream'in kullanildigi yerlerde guncelleme saglanir. Boylece veri getirmek icin tekrar metodu cagirman veya bir butona tiklaman gerekmez;
  ///void getNotesStream() async {
  ///await for (var snapshot in _firestore.collection('notes').snapshots()) {
  ///for (var message in snapshot.docs) {
  ///print(message.data());
  ///}
  ///  }
  ///}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, NoteTypeSelectionPage.id);
            }),
        title: Text(
          'Note List',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 10.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    minimumSize: Size(50.0, 30.0),
                  ),
                  onPressed: (() {
                    //TODO:Eklendikten sonra notlarin slayt seklinde listelendigi sayfaya gecis yapilacak;
                    Navigator.pushNamed(context, NoteSlidePage.id);
                    //getNotesStream();
                  }),
                  child: Text(
                    'Note Slides',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushNamed(context, LoginPage.id);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            NoteStream(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //mini:true,
        backgroundColor: Colors.lightBlue[900],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String baslik = ''; // burada varsayılan değer atanması gerekiyor
              String metin = ''; // burada varsayılan değer atanması gerekiyor
              return AlertDialog(
                title: Text('Add New Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        baslik = value; // baslik burada güncelleniyor
                      },
                      decoration: InputDecoration(
                        labelText: 'Caption',
                        hintText: 'Note Caption',
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          metin = value; // metin burada güncelleniyor
                        },
                        decoration: InputDecoration(
                          labelText: 'Content',
                          hintText: 'Note Content',
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900]),
                    onPressed: () {
                      if (baslik.isNotEmpty && metin.isNotEmpty) {
                        //=>Giris yapan kullanicinin mail adresi ile ona ozgu kilacak sekilde ekledigi not Firebase Firestore'a kaydedilir;
                        _firestore.collection('notes').add({
                          'caption': baslik,
                          'content': metin,
                          'noteOwner': loggedInUser.email,
                          'time': Timestamp.now(),
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.red[900]),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NotDetay extends StatefulWidget {
  Not not;
  NotDetay(this.not);

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  String caption = "";
  String content = "";

  @override
  void initState() {
    if (widget.not.baslik != null && widget.not.metin != null) {
      caption = widget.not.baslik;
      content = widget.not.metin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text(caption, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                minimumSize: Size(30.0, 10.0),
              ),
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit The Note'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                caption = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'New Caption',
                                hintText: 'Note Caption',
                              ),
                            ),
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  content = value; // metin burada güncelleniyor
                                },
                                decoration: InputDecoration(
                                  labelText: 'New Content',
                                  hintText: 'Note Content',
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[900]),
                            onPressed: () {
                              if (caption.isNotEmpty && content.isNotEmpty) {
                                _firestore
                                    .collection('notes')
                                    .doc(widget.not.docId)
                                    .update({
                                  'caption': caption,
                                  'content': content,
                                  //'time': Timestamp.now()
                                });
                                //Navigator.of(context).pop();
                                //=>Guncelleme yapilirsa liste ekranina geci yapip guncellenen notu gosteriyor;
                                Navigator.pushNamed(context, NoteListPage.id);
                              }
                            },
                            child: Text('Update'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red[900]),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    });
              }),
              child: Text(
                'Edit Note',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(content, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class Not extends StatelessWidget {
  final dynamic docId;
  final String baslik;
  final String metin;

  Not({required this.docId, this.baslik = '', this.metin = ''});

  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.lightBlue[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.lightBlue[800],
      child: ListTile(
        trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sil'),
                    content: Text(
                      'Notu silmek istediğinizden emin misiniz?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red[900]),
                        child: const Text(
                          'Hayır',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900]),
                        child: const Text(
                          'Evet',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //=>Trash ikonuna tiklanildiginda ilgili not Firebase Firestore'dan silinir ve stream
                          //kullanimi sayesinde listeden de otomatik olarak kaldirilir (notify edilir);
                          _firestore.collection('notes').doc(docId).delete();
                          //print("Deleted!");
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            )),
        title: Text(
          baslik,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          metin,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotDetay(this),
            ),
          );
        },
      ),
    );
  }
}

//**=>Stream kullanimiyla Firebase Firestore'dan cekilen notlari liste halinde (ListView icerisinde) getirmek icin;
class NoteStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('notes')
          .orderBy('time') //desc:false
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //=>henuz veri cekilmemisken hata verilmemesi adina CircularProgressIndicator ile loading
          //animasyonu gosterilir;
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final notes = snapshot.data?.docs;
        List<Not> notlar = [];
        for (var note in notes!) {
          final noteCaption = note['caption'];
          final noteContent = note['content'];
          final noteOwner = note['noteOwner'];
          final currentUser = loggedInUser.email;
          //Yalnizca login olan kullaniciya ait notlari getirmek ve listelemek icin;
          if (noteOwner == currentUser) {
            final noteCard =
                Not(docId: note.id, baslik: noteCaption, metin: noteContent);
            notlar.add(noteCard);
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: notlar,
          ),
        );
      },
    );
  }
}
