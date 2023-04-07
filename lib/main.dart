import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Info Cards")),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: const [
                    Card(
                        child:
                            Text("Card 1") // Card content for the first page,
                        ),
                    Card(
                        child:
                            Text("Card 2") // Card content for the second page,
                        ),
                    Card(
                        child:
                            Text("Card 3") // Card content for the second page,
                        ),
                    // Add more cards as needed
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('Previous'),
                onPressed: () {
                  _controller.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
