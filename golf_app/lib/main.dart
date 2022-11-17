import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:golf_app/globals.dart' as globals;
import 'dart:math';
import 'package:collection/collection.dart';
import 'dart:async';

StreamController<List<Stat>> streamController = StreamController<List<Stat>>();
StreamController<List<Stat>> streamControllerGreen =
    StreamController<List<Stat>>();
StreamController<List<Stat>> streamControllerDrive =
    StreamController<List<Stat>>();

class BottomNavBarItemData {
  final String label;
  final Icon icon;
  final Widget screen;

  BottomNavBarItemData(
    this.label,
    this.icon,
    this.screen,
  );
}

void main() => runApp(const MyApp());

class Game {
  int score;
  String course;
  int par;
  Game(this.score, this.course, this.par);
}

class Stat {
  int fairway;
  int green;
  int putt;
  Stat(this.fairway, this.green, this.putt);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({super.key});
  int selectedIdx = 0;

  final List<BottomNavBarItemData> screens = [
    BottomNavBarItemData(
      "Home",
      Icon(Icons.home),
      Games(),
    ),
    BottomNavBarItemData(
      "Stats",
      Icon(Icons.article_outlined),
      Stats(),
    ),
    BottomNavBarItemData(
      "Putts",
      Icon(Icons.area_chart_rounded),
      Putts(pricePoints, streamController.stream),
    ),
    BottomNavBarItemData(
      "GIR",
      Icon(Icons.area_chart),
      Gir(pricePoints, streamControllerGreen.stream),
    ),
    BottomNavBarItemData(
      "Drives",
      Icon(Icons.area_chart_rounded),
      Drives(pricePoints, streamControllerDrive.stream),
    ),
  ];

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with AutomaticKeepAliveClientMixin<MyStatefulWidget> {
  //List pages = [MyStatefulWidget(), Stats()];
  @override
  bool get wantKeepAlive => true;

  /*List<Game> ScoreList = <Game>[
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
      ScoreList.add(s);
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

  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
/*
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.selectedIdx,
        onTap: (idx) => setState(() {
          widget.selectedIdx = idx;
        }),
        items: widget.screens
            .map(
              (e) => BottomNavigationBarItem(
                label: e.label,
                icon: e.icon,
                backgroundColor: Colors.grey,
              ),
            )
            .toList(),
      ),
      body: IndexedStack(
        index: widget.selectedIdx,
        children: [
          ...widget.screens.map((e) => e.screen).toList(),
        ],
      ),
      /*appBar: AppBar(
        title: Text('Handicap: $fin'),
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
                    validator: (val) =>
                        NotIntCheck(val) ? 'Enter Score,Number Required' : null,
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
              rows: ScoreList.map(
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Graph',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          switch (index) {
            case 0:
              MyStatefulWidget();
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new MyStatefulWidget()));
              // _navigatorKey.currentState.pushReplacementNamed("Page 1");
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Stats()),
              );
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              //  _navigatorKey.currentState.pushReplacementNamed("Page 2");
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Stats()),
              );
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              // _navigatorKey.currentState.pushReplacementNamed("Profile");
              break;
          }
        },
      ),*/
    );
  }
}

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games>
    with AutomaticKeepAliveClientMixin<Games> {
  //List pages = [MyStatefulWidget(), Stats()];
  @override
  bool get wantKeepAlive => true;

  List<Game> ScoreList = <Game>[
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
      fin = double.parse((fin.toStringAsFixed(1)));
      //ID_Controller.text = lastID.toString();
    });
  }

  //Method used to refresh UI after removed data
  refreshListRemove(int s, int p) {
    setState(() {
      total = total - (s - p);
      c--;
      fin = total / c;
      fin = double.parse((fin.toStringAsFixed(1)));
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
      ScoreList.add(s);
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

  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
/*
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handicap: $fin'),
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
                    validator: (val) =>
                        NotIntCheck(val) ? 'Enter Score,Number Required' : null,
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
                  DataColumn(label: Text("Delete")),
                ],
                rows: ScoreList.map(
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
                    DataCell(IconButton(
                        onPressed: () {
                          setState(() {
                            ScoreList.remove(s);
                            refreshListRemove(s.score, s.par);
                          });
                        },
                        icon: Icon(Icons.delete))),
                  ]),
                ).toList(),
              )),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Graph',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          switch (index) {
            case 0:
              MyStatefulWidget();
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new MyStatefulWidget()));
              // _navigatorKey.currentState.pushReplacementNamed("Page 1");
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Stats()),
              );
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              //  _navigatorKey.currentState.pushReplacementNamed("Page 2");
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Stats()),
              );
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              // _navigatorKey.currentState.pushReplacementNamed("Profile");
              break;
          }
        },
      ),*/
    );
  }
}

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats>
    with AutomaticKeepAliveClientMixin<Stats> {
  @override
  bool get wantKeepAlive => true;

  List<Stat> StatList = <Stat>[
    //Game(82, "Bidwell Golf Course"),
    //Game(79, "Los Lagos Golf Course"),
  ];

  final formKey = new GlobalKey<FormState>();
  var Fairway_Controller = new TextEditingController();
  var Green_Controller = new TextEditingController();
  var Putt_Controller = new TextEditingController();
  //var lastID = 2;
  double totalPutts = 0;
  double totalGreens = 0;
  double totalFairways = 0;
  double finPutts = 0;
  double finGreens = 0;
  double finFairways = 0;
  var count = 0;

  @override
  // Method that call only once to initiate the default app.
  void initState() {
    super.initState();
    //lastID++;
    //ID_Controller.text = lastID.toString();
  }

  // Method that is used to refresh the UI and show the new inserted data.
  refreshList(int f, int g, int p) {
    setState(() {
      totalPutts = totalPutts + p / 18;
      totalGreens = totalGreens + g / 18;
      totalFairways = totalFairways + f / 18;
      count++;
      finPutts = totalPutts / count;
      finGreens = totalGreens / count;
      finFairways = totalFairways / count;
      finGreens = finGreens * 100;
      finFairways = finFairways * 100;
      finPutts = double.parse((finPutts).toStringAsFixed(1));
      finGreens = double.parse((finGreens).toStringAsFixed(1));
      finFairways = double.parse((finFairways).toStringAsFixed(1));
      //ID_Controller.text = lastID.toString();
    });
  }

  refreshListRemove(int f, int g, int p) {
    setState(() {
      totalPutts = totalPutts - p / 18;
      totalGreens = totalGreens - g / 18;
      totalFairways = totalFairways - f / 18;
      count--;
      finPutts = totalPutts / count;
      finGreens = totalGreens / count;
      finFairways = totalFairways / count;
      finGreens = finGreens * 100;
      finFairways = finFairways * 100;
      finPutts = finPutts * 1;
      finPutts = double.parse((finPutts).toStringAsFixed(1));
      finGreens = double.parse((finGreens).toStringAsFixed(1));
      finFairways = double.parse((finFairways).toStringAsFixed(1));
    });
  }

  // Method used to validate the user data
  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String Fairway = Fairway_Controller.text;
      String Green = Green_Controller.text;
      String Putt = Putt_Controller.text;
      Stat s = Stat(int.parse(Fairway), int.parse(Green), int.parse(Putt));
      StatList.add(s);

      streamController.add(StatList);
      streamControllerGreen.add(StatList);
      streamControllerDrive.add(StatList);

      globals.gStat gS =
          globals.gStat(int.parse(Fairway), int.parse(Green), int.parse(Putt));
      globals.gList.add(gS);
      //lastID++;
      refreshList(int.parse(Fairway), int.parse(Green), int.parse(Putt));
      Fairway_Controller.text = "";
      Green_Controller.text = "";
      Putt_Controller.text = "";
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

  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
/*
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Avg Putts: $finPutts, Greens Hit: $finGreens%, Fairways Hit: $finFairways%'),
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
                  Text("Fairways Hit:"),
                  TextFormField(
                    controller: Fairway_Controller,
                    keyboardType: TextInputType.number,
                    validator: (val) => NotIntCheck(val)
                        ? 'Enter Fairways Hit,Number Required'
                        : null,
                  ),
                  Text("Greens Hit:"),
                  TextFormField(
                    controller: Green_Controller,
                    keyboardType: TextInputType.text,
                    validator: (val) => NotIntCheck(val)
                        ? 'Enter Greens Hit,Number Required'
                        : null,
                  ),
                  Text("Putts:"),
                  TextFormField(
                    controller: Putt_Controller,
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        NotIntCheck(val) ? 'Enter Putts,Number Required' : null,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Insert Stats',
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
                  label: Text("Fairways Hit"),
                ),
                DataColumn(
                  label: Text("GIR"),
                ),
                DataColumn(
                  label: Text("Putts"),
                ),
                DataColumn(label: Text("Delete")),
              ],
              rows: StatList.map(
                (s) => DataRow(cells: [
                  DataCell(
                    Text(s.fairway.toString()),
                  ),
                  DataCell(
                    Text(s.green.toString()),
                  ),
                  DataCell(
                    Text(s.putt.toString()),
                  ),
                  DataCell(IconButton(
                      onPressed: () {
                        setState(() {
                          StatList.remove(s);
                          streamController.add(StatList);
                          streamControllerGreen.add(StatList);
                          streamControllerDrive.add(StatList);
                          globals.gList.remove(s);
                          refreshListRemove(s.fairway, s.green, s.putt);
                        });
                      },
                      icon: Icon(Icons.delete))),
                ]),
              ).toList(),
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Graph',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStatefulWidget()),
              );
              //Navigator.pop(context);
              //Navigator.of(context).pushReplacement(new MaterialPageRoute(
              //builder: (context) => new MyStatefulWidget()));
              // _navigatorKey.currentState.pushReplacementNamed("Page 1");
              break;
            case 1:
              Stats();
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              //  _navigatorKey.currentState.pushReplacementNamed("Page 2");
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Stats()),
              );
              //Navigator.of(context).pushReplacement(
              //new MaterialPageRoute(builder: (context) => new Stats()));
              // _navigatorKey.currentState.pushReplacementNamed("Profile");
              break;
          }
        },
      ),*/
    );
  }
}

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  /*final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();*/
  /*final randomNumbers = <double>[];
  randomNumbers.add(0);
  randomNumbers.add(0);
  for (var i = 0; i <= globals.gList.length; i++) {
    randomNumbers.add(globals.gList[i].putt.toDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();*/
  List<PricePoint> l = <PricePoint>[];
  for (var i = 0; i < globals.gList.length; i++) {
    l.add(PricePoint(x: globals.gList[i].putt.toDouble(), y: i.toDouble()));
  }
  return l;
}

class Putts extends StatefulWidget {
  final List<PricePoint> points;
  final Stream<List<Stat>> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Putts(this.points, this.stream);

  @override
  _PuttsState createState() => _PuttsState();
}

class _PuttsState extends State<Putts> {
  List<PricePoint> points = <PricePoint>[];
  /*final Stream<int> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Graphs(this.points, this.stream);*/

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

//switch to l.add(list) parameter
  void mySetState(List<Stat> list) {
    //List menuList = ['A', 'B', 'C'];
    setState(() {
      List<PricePoint> l = <PricePoint>[];
      /*for (var i = 0; i < globals.gList.length; i++) {
        l.add(PricePoint(x: globals.gList[i].putt.toDouble(), y: i.toDouble()));
      }*/
      for (var i = 0; i < list.length; i++) {
        l.add(PricePoint(x: list[i].putt.toDouble(), y: i.toDouble()));
      }
      points = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.y, point.x)).toList(),
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gir extends StatefulWidget {
  final List<PricePoint> points;
  final Stream<List<Stat>> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Gir(this.points, this.stream);

  @override
  _GirState createState() => _GirState();
}

class _GirState extends State<Gir> {
  List<PricePoint> points = <PricePoint>[];
  /*final Stream<int> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Graphs(this.points, this.stream);*/

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

//switch to l.add(list) parameter
  void mySetState(List<Stat> list) {
    //List menuList = ['A', 'B', 'C'];
    setState(() {
      List<PricePoint> l = <PricePoint>[];
      /*for (var i = 0; i < globals.gList.length; i++) {
        l.add(PricePoint(x: globals.gList[i].putt.toDouble(), y: i.toDouble()));
      }*/
      for (var i = 0; i < list.length; i++) {
        l.add(PricePoint(x: list[i].green.toDouble(), y: i.toDouble()));
      }
      points = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.y, point.x)).toList(),
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class Drives extends StatefulWidget {
  final List<PricePoint> points;
  final Stream<List<Stat>> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Drives(this.points, this.stream);

  @override
  _DrivesState createState() => _DrivesState();
}

class _DrivesState extends State<Drives> {
  List<PricePoint> points = <PricePoint>[];
  /*final Stream<int> stream;

  //const Graphs(this.points, {Key? key}) : super(key: key);
  const Graphs(this.points, this.stream);*/

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

//switch to l.add(list) parameter
  void mySetState(List<Stat> list) {
    //List menuList = ['A', 'B', 'C'];
    setState(() {
      List<PricePoint> l = <PricePoint>[];
      /*for (var i = 0; i < globals.gList.length; i++) {
        l.add(PricePoint(x: globals.gList[i].putt.toDouble(), y: i.toDouble()));
      }*/
      for (var i = 0; i < list.length; i++) {
        l.add(PricePoint(x: list[i].fairway.toDouble(), y: i.toDouble()));
      }
      points = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.y, point.x)).toList(),
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
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
}*/
