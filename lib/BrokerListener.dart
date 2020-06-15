import 'package:flutter/material.dart';
import 'package:mqttmonitor/MQTThelper.dart';

// || ||
// ||_||
// \___/
// Oliver Ursell

class BrokerListener extends StatefulWidget {

  final String brokerText;

  BrokerListener({@required this.brokerText});

  @override
  _BrokerListenerState createState() =>
      _BrokerListenerState(brokerText: this.brokerText);
}

class _BrokerListenerState extends State<BrokerListener> {

  MQTThelper mqtt;

  String brokerText;
  String topic;


  @override
  void initState() {
    super.initState();
    mqtt = new MQTThelper(brokerAddress: brokerText, onMessageReceived: (text) {
      print(text);
      printTextToScreen(text);
    });
  }

  set setTopic(String topic) {
    if(this.topic != null) mqtt.unsubscribe(this.topic);
    this.topic = topic;
    mqtt.subscribe(this.topic);
  }

  List<String> textOutput = new List<String>();
  bool reversed = false;
  ScrollController textScrollController = new ScrollController();

  void printTextToScreen(String text) {
    setState(() {
      textOutput.add(text);
      textScrollController.jumpTo(
          textScrollController.position.maxScrollExtent + 20);
    });
  }

  void sendMessage(String message){
    mqtt.publish(topic, message);
  }

  _BrokerListenerState({@required this.brokerText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brokerText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                "Topic",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              autofocus: true,
              onSubmitted: (text) {
                setTopic = text;
              },
              decoration: InputDecoration(
                hintText: "Enter the topic to monitor",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  "Messages",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: textOutput.length,
                  controller: textScrollController,
                  itemBuilder: (context, position) {
                    return Text(textOutput[position],
                      style: TextStyle(
                          fontSize: 20
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          openSendMessageDialog();
        },
      ),
    );
  }

  final textController = TextEditingController();

  void openSendMessageDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Send message to $topic"),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Send a message to $topic'
                  ),
                  autofocus: true,
                  onSubmitted: (submittedValue) {
                    sendMessage(submittedValue);
                    setState(() {
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
                  sendMessage(textController.text);
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void deactivate() {
    super.deactivate();
    mqtt.disconnect();
  }
}
