import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlSolar v2',
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
        primarySwatch: Colors.red,
        textTheme: TextTheme(
          title: TextStyle(),
          subhead: TextStyle(
            // color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(title: 'AlSolar v2.1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _sending = false;

  bool _sentOnce = false;

  String _responseText = '';

  bool _responseStatus = false;

  bool _progressBarVisible = false;

  Future<bool> _sendCommand(String command, String value) async {
    if (_sending) {
      return false;
    }
    if (command == '') {
      return false;
    }
    setState(() {
      _sending = true;
      _progressBarVisible = true;
    });
    print('$command command WILL be sent with $value value.');
    // var url = 'http://10.0.2.2/1tests/arduino/?CMD=$command&VAL=$value';
    var url = 'http://192.168.44.1/RIM?CMD=$command&VAL=$value';
    print(url);
    var response = await http.get(url).timeout(const Duration(seconds: 3)).then(
      (_response) {
        print('$command command is sent successfully with $value value.');
        if (_response.statusCode == 200) {
          print('Yeey : ${_response.body}');
        } else if (_response.statusCode == 202) {
          print('Yeey buy neey. No body.');
        } else {
          print('Something went wrong. ${_response.body}');
        }
        setState(() {
          _sentOnce = true;
          _sending = false;
          _progressBarVisible = false;
          _responseText = _response.statusCode != 202 ? _response.body : '';
          _responseStatus = _response.statusCode != 202 ? true : false;
        });
      },
      onError: (_response) {
        _timeout(_response);
      },
    );

    return true;
  }

  void _launchRimtay() async {
    const url = 'https://rimtay.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        _responseText = 'https://rimtay.com';
        _responseStatus = true;
      });
    }
  }

  void _timeout(_response) {
    print('Something went wrong.');
    print(_response);
    setState(() {
      _responseText = 'Bir şeyler ters gitti...';
      _responseStatus = false;
      _sentOnce = true;
      _sending = false;
      _progressBarVisible = false;
    });
  }

  void _refreshStats() {
    _sendCommand('RIMCOMMAND', 'REFRESH');
  }

  void _buttonSendCommand(String command) {
    _sendCommand('RIMBUTTON', command);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          MaterialButton(
            onPressed: _launchRimtay,
            child: Container(
              width: 60,
              child: Image.asset('assets/images/favicon-black.png'),
              margin: EdgeInsets.only(right: 20),
            ),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   margin: EdgeInsets.all(30),
              //   child: Table(
              //     // defaultColumnWidth: FractionColumnWidth(0.15),
              //     // defaultColumnWidth: IntrinsicColumnWidth(),
              //     columnWidths: {
              //       0: FractionColumnWidth(.3),
              //       4: FractionColumnWidth(0.3)
              //     },
              //     children: [
              //       TableRow(
              //         children: <Widget>[
              //           Text(
              //             'Sistem Hızı:',
              //             style: Theme.of(context).textTheme.subhead,
              //           ),
              //           Icon(Icons.arrow_upward),
              //           Text(
              //             '30',
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             'Sistem Yönü:',
              //             style: Theme.of(context).textTheme.subhead,
              //           ),
              //           Icon(Icons.arrow_forward),
              //           Text(
              //             '30',
              //           ),
              //         ],
              //       ),
              //       TableRow(
              //         children: <Widget>[
              //           Text(
              //             'Sistem Hızı:',
              //             style: Theme.of(context).textTheme.subhead,
              //           ),
              //           Icon(Icons.arrow_upward),
              //           Text(
              //             '30',
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             'Sistem Yönü:',
              //             style: Theme.of(context).textTheme.subhead,
              //           ),
              //           Icon(Icons.arrow_forward),
              //           Text(
              //             '30',
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "1",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("1");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "2",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("2");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "3",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("3");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "4",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("4");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "5",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("5");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "6",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("6");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "7",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("7");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "8",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("8");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "9",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("9");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "*",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("ASTERIX");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "0",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("0");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: FlatButton(
                            child: Text(
                              "#",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              _buttonSendCommand("SHARP");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: FlatButton(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _buttonSendCommand("BACK");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: FlatButton(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _buttonSendCommand("FORWARD");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: FlatButton(
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _buttonSendCommand("UPWARD");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: FlatButton(
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _buttonSendCommand("DOWNWARD");
                            },
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: _sentOnce
                          ? Text(
                              _responseText != ''
                                  ? _responseText
                                  : 'Cevap yok.\n\n\n',
                              style: _responseStatus
                                  ? TextStyle(color: Colors.green, fontSize: 20)
                                  : TextStyle(
                                      color: Colors.orange, fontSize: 20),
                            )
                          : Text(
                              'Sistem ile iletişime geçilmedi.\n\n\n',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Visibility(
              //   visible: _progressBarVisible,
              //   child: Container(
              //       margin: EdgeInsets.only(bottom: 30),
              //       child: CircularProgressIndicator()),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshStats,
        tooltip: 'Yenile',
        child: _progressBarVisible
            ? Icon(Icons.cloud_upload)
            : Icon(Icons.refresh),
        backgroundColor: _progressBarVisible
            ? Colors.orange
            : Theme.of(context).primaryColor,
      ),
    );
  }
}
