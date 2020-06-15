import 'package:flutter/material.dart';
import 'package:mqttmonitor/BrokerListener.dart';
import 'main.dart';

// || ||
// ||_||
// \___/
// Oliver Ursell

class BrokerSelector extends StatefulWidget {
  final String text;
  final List<String> brokers;
  final State<HomeView> homeViewState;

  BrokerSelector({
    @required this.text,
    @required this.brokers,
    @required this.homeViewState
  });

  @override
  _BrokerSelectorState createState() =>
      _BrokerSelectorState(brokers, text, homeViewState);

}

class _BrokerSelectorState extends State<BrokerSelector> {

  String text;
  bool enabled = false;
  List<String> brokers;
  State<HomeView> homeViewState;

  _BrokerSelectorState(List<String> brokers, String text,
      State<HomeView> homeViewState) {
    this.text = text;
    this.brokers = brokers;
    this.homeViewState = homeViewState;
  }

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return GestureDetector(
        onHorizontalDragUpdate: (update) {
          if (update.delta.direction == 0) {
            homeViewState.setState(() {
              this.enabled = false;
            });
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(""),
                    Text("$text",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
                onPressed: () {
                  Navigator.of(homeViewState.context).push(
                      MaterialPageRoute(builder: (context) => BrokerListener(brokerText: text))
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Uncomment for edit button
//                  Expanded(
//                    child: RaisedButton(
//                      color: Colors.amber,
//                      child: Icon(Icons.edit),
//                      onPressed: () {
//                        openEditor(this.text);
//                      },
//                    ),
//                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                      onPressed: () {
                        homeViewState.setState(() {
                          brokers.remove(this.text);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: GestureDetector(
              onHorizontalDragUpdate: (update) {
                if (update.delta.direction != 0) {
                  setState(() {
                    this.enabled = true;
                  });
                }
              },
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(""),
                    Text("$text",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    Icon(Icons.chevron_left),
                  ],
                ),
                onPressed: () {
                  Navigator.of(homeViewState.context).push(
                      MaterialPageRoute(builder: (context) => BrokerListener(brokerText: text))
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }
}