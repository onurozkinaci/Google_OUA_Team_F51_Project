import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appjamproject/pages/login_page.dart';

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
        print(loggedInUser.email);
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
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.id);
            }),
        title: Text(
          'Not Listesi',
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
                    print("Not slaytı sayfası açıldı.");
                    //getNotesStream();
                  }),
                  child: Text(
                    'Not Slaytı',
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String baslik = ''; // burada varsayılan değer atanması gerekiyor
              String metin = ''; // burada varsayılan değer atanması gerekiyor
              return AlertDialog(
                title: Text('Yeni Not Ekle'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        baslik = value; // baslik burada güncelleniyor
                      },
                      decoration: InputDecoration(
                        labelText: 'Başlık',
                        hintText: 'Not Başlığı',
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          metin = value; // metin burada güncelleniyor
                        },
                        decoration: InputDecoration(
                          labelText: 'Metin',
                          hintText: 'Not Metni',
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
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
                    child: Text('Ekle'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('İptal'),
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
        title: Text(caption),
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
                        title: Text('Notu Guncelle'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                caption = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Yeni Başlık',
                                hintText: 'Not Başlığı',
                              ),
                            ),
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  content = value; // metin burada güncelleniyor
                                },
                                decoration: InputDecoration(
                                  labelText: 'Yeni Metin',
                                  hintText: 'Not Metni',
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              if (caption.isNotEmpty && content.isNotEmpty) {
                                _firestore
                                    .collection('notes')
                                    .doc(widget.not.docId)
                                    .update({
                                  'caption': caption,
                                  'content': content,
                                  'time': Timestamp.now()
                                });
                                //Navigator.of(context).pop();
                                //=>Guncelleme yapilirsa liste ekranina geci yapip guncellenen notu gosteriyor;
                                Navigator.pushNamed(context, NoteListPage.id);
                              }
                            },
                            child: Text('Güncelle'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('İptal'),
                          ),
                        ],
                      );
                    });
              }),
              child: Text(
                'Notu Düzenle',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(content),
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
      color: Colors.teal,
      child: ListTile(
        trailing: IconButton(
            onPressed: () {
              //=>Trash ikonuna tiklanildiginda ilgili not Firebase Firestore'dan silinir ve stream
              //kullanimi sayesinde listeden de otomatik olarak kaldirilir (notify edilir);
              _firestore.collection('notes').doc(docId).delete();
              //print("Deleted!");
            },
            icon: Icon(Icons.delete)),
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
