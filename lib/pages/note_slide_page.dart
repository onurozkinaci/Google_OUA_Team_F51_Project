import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appjamproject/pages/note_list_page.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class NoteSlidePage extends StatefulWidget {
  static const String id = 'note_slide_page';
  //final List<Not> notlar;

  @override
  State<NoteSlidePage> createState() => _NoteSlidePageState();
}

class _NoteSlidePageState extends State<NoteSlidePage> {
  final _auth = FirebaseAuth.instance;

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
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, NoteListPage.id);
            }),
        backgroundColor: Colors.lightBlue[900],
        title: const Text('Note Slides'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            NoteSlideStream(),
          ],
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String baslik;
  final String metin;

  NoteCard({this.baslik = '', this.metin = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Card(
          elevation: 8,
          shadowColor: Colors.lightBlue[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.teal[900],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      baslik,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      metin,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//**=>Stream kullanimiyla Firebase Firestore'dan cekilen notlari liste halinde (PageView icerisinde) getirmek icin;
class NoteSlideStream extends StatelessWidget {
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
        List<NoteCard> noteCards = [];
        for (var note in notes!) {
          final noteCaption = note['caption'];
          final noteContent = note['content'];
          final noteOwner = note['noteOwner'];
          final currentUser = loggedInUser.email;
          //Yalnizca login olan kullaniciya ait notlari getirmek ve listelemek icin;
          if (noteOwner == currentUser) {
            final noteCard = NoteCard(baslik: noteCaption, metin: noteContent);
            noteCards.add(noteCard);
          }
        }
        return Expanded(
          child: PageView(
            controller: PageController(viewportFraction: 0.8),
            children: noteCards,
          ),
        );
      },
    );
  }
}
