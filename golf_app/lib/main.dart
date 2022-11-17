import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
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
  @override
  bool get wantKeepAlive => true;

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
  @override
  bool get wantKeepAlive => true;

  List<Game> ScoreList = <Game>[];

  final formKey = new GlobalKey<FormState>();
  var Score_Controller = new TextEditingController();
  var Course_Controller = new TextEditingController();
  var Par_Controller = new TextEditingController();
  var total = 0;
  double fin = 0;
  var c = 0;

  @override
  // Method that call only once to initiate the app
  void initState() {
    super.initState();
  }

  // Method that is used to refresh the UI and show the new inserted data.
  refreshList(int s, int p) {
    setState(() {
      total = total + s - p;
      c++;
      fin = total / c;
      fin = double.parse((fin.toStringAsFixed(1)));
    });
  }

  //Method used to refresh UI after removed data
  refreshListRemove(int s, int p) {
    setState(() {
      total = total - (s - p);
      c--;
      fin = total / c;
      fin = double.parse((fin.toStringAsFixed(1)));
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

  List<Stat> StatList = <Stat>[];

  final formKey = new GlobalKey<FormState>();
  var Fairway_Controller = new TextEditingController();
  var Green_Controller = new TextEditingController();
  var Putt_Controller = new TextEditingController();
  double totalPutts = 0;
  double totalGreens = 0;
  double totalFairways = 0;
  double finPutts = 0;
  double finGreens = 0;
  double finFairways = 0;
  var count = 0;

  @override
  // Method that call only once to initiate the app.
  void initState() {
    super.initState();
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
    );
  }
}

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  List<PricePoint> l = <PricePoint>[];
  return l;
}

class Putts extends StatefulWidget {
  final List<PricePoint> points;
  final Stream<List<Stat>> stream;

  const Putts(this.points, this.stream);

  @override
  _PuttsState createState() => _PuttsState();
}

class _PuttsState extends State<Putts> {
  List<PricePoint> points = <PricePoint>[];

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

  void mySetState(List<Stat> list) {
    setState(() {
      List<PricePoint> l = <PricePoint>[];
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

  const Gir(this.points, this.stream);

  @override
  _GirState createState() => _GirState();
}

class _GirState extends State<Gir> {
  List<PricePoint> points = <PricePoint>[];

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

  void mySetState(List<Stat> list) {
    setState(() {
      List<PricePoint> l = <PricePoint>[];
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

  const Drives(this.points, this.stream);

  @override
  _DrivesState createState() => _DrivesState();
}

class _DrivesState extends State<Drives> {
  List<PricePoint> points = <PricePoint>[];

  @override
  void initState() {
    super.initState();
    widget.stream.listen((list) {
      mySetState(list);
    });
  }

  void mySetState(List<Stat> list) {
    setState(() {
      List<PricePoint> l = <PricePoint>[];
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
            ),
          ],
        ),
      ),
    );
  }
}
