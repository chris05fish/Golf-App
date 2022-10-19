import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(InsertDataTable());
  //runApp(const MyApp());
}

class Game {
  int score;
  String course;
  int par;
  Game(this.score, this.course, this.par);
}

class InsertDataTable extends StatefulWidget {
  @override
  _InsertDataTableState createState() => new _InsertDataTableState();
}

class _InsertDataTableState extends State<InsertDataTable> {
  List<Game> ScoreLst = <Game>[
    //Game(82, "Bidwell Golf Course"),
    //Game(79, "Los Lagos Golf Course"),
  ];

  final formKey = new GlobalKey<FormState>();
  var Score_Controller = new TextEditingController();
  var Course_Controller = new TextEditingController();
  var Par_Controller = new TextEditingController();
  //var lastID = 2;
  var total = 0;
  double fin = 0;
  var c = 0;

  @override
  // Method that call only once to initiate the default app.
  void initState() {
    super.initState();
    //lastID++;
    //ID_Controller.text = lastID.toString();
  }

  // Method that is used to refresh the UI and show the new inserted data.
  refreshList(int s, int p) {
    setState(() {
      total = total + s - p;
      c++;
      fin = total / c;
      //ID_Controller.text = lastID.toString();
    });
  }

  // Method used to validate the user data
  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String Score = Score_Controller.text;
      String Course = Course_Controller.text;
      String Par = Par_Controller.text;
      Game s = Game(int.parse(Score), Course, int.parse(Par));
      ScoreLst.add(s);
      //lastID++;
      refreshList(int.parse(Score), int.parse(Par));
      Score_Controller.text = "";
      Course_Controller.text = "";
      Par_Controller.text = "";
    }
  }

  // Method to check the value of age, age is int or not
  bool NotIntCheck(var N) {
    final V = int.tryParse(N);

    if (V == null) {
      print("Not Int");
      return true;
    } else {
      print("Int");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp with home as scaffold
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Handicap: $fin',
          ), //var age; print('Age is: $age');
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Score:"),
                    TextFormField(
                      controller: Score_Controller,
                      keyboardType: TextInputType.number,
                      validator: (val) => NotIntCheck(val)
                          ? 'Enter Score,Number Required'
                          : null,
                    ),
                    Text("Course Name:"),
                    TextFormField(
                      controller: Course_Controller,
                      keyboardType: TextInputType.text,
                      validator: (val) =>
                          val?.length == 0 ? 'Enter Course Name' : null,
                    ),
                    Text("Par:"),
                    TextFormField(
                      controller: Par_Controller,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          NotIntCheck(val) ? 'Enter Par,Number Required' : null,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'Insert Score',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: validate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Score"),
                  ),
                  DataColumn(
                    label: Text("Course Name"),
                  ),
                  DataColumn(
                    label: Text("Par"),
                  ),
                ],
                rows: ScoreLst.map(
                  (s) => DataRow(cells: [
                    DataCell(
                      Text(s.score.toString()),
                    ),
                    DataCell(
                      Text(s.course),
                    ),
                    DataCell(
                      Text(s.par.toString()),
                    ),
                  ]),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handicap: ',
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
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Golf Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
