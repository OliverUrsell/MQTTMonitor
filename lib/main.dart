import 'package:flutter/material.dart';
import 'BrokerSelector.dart';

// || ||
// ||_||
// \___/
// Oliver Ursell

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> brokers = new List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: Text("Select Broker")),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              openEditor("");
            });
          }),
      body: Center(
          child: ListView.builder(
            itemCount: brokers.length,
            itemBuilder: (context, position) {
              return Container(
                height: 75,
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(width: 3, color: Colors.grey))),
                child: BrokerSelector(
                  text: "${brokers[position]}",
                  brokers: brokers,
                  homeViewState: this,
                ),
              );
            },
          )),
    );
  }

  final textController = TextEditingController();

  void openEditor(String text) {

    textController.text = text;

    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Add / Edit broker"),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the address of a broker'
                  ),
                  autofocus: true,
                  controller: textController,
                  onSubmitted: (submittedValue) {
                    setState(() {
                      brokers.add(submittedValue);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {Navigator.pop(context);},
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  setState(() {
                    if(!brokers.contains(textController.text)){
                      brokers.add(textController.text);
                    }
                    if(brokers.contains("")){
                      brokers.remove("");
                    }
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
