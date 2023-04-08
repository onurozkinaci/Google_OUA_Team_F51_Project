import 'package:flutter/material.dart';
import 'package:flutter_appjamproject/pages/login_page.dart';
import 'package:flutter_appjamproject/pages/note_list_page.dart';

class NoteTypeSelectionPage extends StatefulWidget {
  static const String id = 'note_type_selection_page';
  @override
  State<NoteTypeSelectionPage> createState() => _NoteTypeSelectionPageState();
}

class _NoteTypeSelectionPageState extends State<NoteTypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.id);
            }),
        backgroundColor: Colors.lightBlue[900],
        title: Text('NOTE TRACKING APP'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          Expanded(
            child: Container(
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 20,
                    child: Material(
                      child: Container(
                          height: 180,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 30,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage('images/info.png')),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 60,
                      left: 200,
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        height: 150,
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, NoteListPage.id);
                              },
                              child: Text(
                                'Individual Notes',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF363f93),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              endIndent: 20.0,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 20,
                    child: Material(
                      child: Container(
                          height: 180,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 30,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage('images/users.png')),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 60,
                      left: 200,
                      child: Container(
                        height: 150,
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Important Info!'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'This page has been developed, coming soon...'),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Image(
                                              image: AssetImage(
                                                  'images/coming_soon2.png')),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Text(
                                              'The users will be able to see the other group members\' notes on the developed page...'),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Other Group Users\' Notes',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF363f93),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              endIndent: 20.0,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
