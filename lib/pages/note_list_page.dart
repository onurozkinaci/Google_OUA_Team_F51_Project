import 'package:flutter/material.dart';

class NoteListPage extends StatefulWidget {
  static const String id = 'note_list_page';

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Not> _notlar = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Not Listesi',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                minimumSize: Size(50.0, 10.0),
              ),
              onPressed: (() {
                //TODO:Eklendikten sonra notlarin slayt seklinde listelendigi sayfaya gecis yapilacak;
                print("Not slaytı sayfası açıldı.");
              }),
              child: Text(
                'Not Slaytına Geç',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notlar.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.teal,
            child: ListTile(
              trailing: IconButton(
                  onPressed: () {
                    //TODO:Ikona tiklandiginda notun silinmesi gerekiyor.
                    print("Deleted!");
                  },
                  icon: Icon(Icons.delete)),
              title: Text(
                _notlar[index].baslik,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _notlar[index].metin,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotDetay(_notlar[index]),
                  ),
                );
              },
            ),
          );
        },
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
                        setState(() {
                          _notlar.add(Not(
                              baslik: baslik,
                              metin:
                                  metin)); // burada named parameter kullanılması gerekiyor
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

class NotDetay extends StatelessWidget {
  final Not not;

  NotDetay(this.not);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(not.baslik),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(not.metin),
      ),
    );
  }
}

class Not {
  String baslik;
  String metin;

  Not({this.baslik = '', this.metin = ''});
}
