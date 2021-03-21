import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/indicator.dart';

class FundProject extends StatefulWidget {
  final UserModel userModel;
  final Project project;

  const FundProject({Key? key, required this.userModel, required this.project})
      : super(key: key);

  @override
  _FundProjectState createState() => _FundProjectState();
}

class _FundProjectState extends State<FundProject> {
  int touchedIndex = -1;

  @override
  void initState() {
    if (Hive.box('budget').get(widget.project.documentId) == null)
      Hive.box('budget').put(widget.project.documentId, 0);
    Hive.box('keyToName').put(widget.project.documentId, widget.project.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = [
      Theme.of(context).primaryColor,
      Theme.of(context).accentColor,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.red,
      Colors.lightGreen,
      Colors.pink,
    ];

    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text("Fund " + widget.project.name),
        gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor
        ]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: Hive.box('budget').listenable(),
          builder: (context, box, _) {
            var box = Hive.box('budget');
            List<String> keys = ['wallet', widget.project.documentId ?? ""];
            List<int> valuesInt = [box.get('wallet'), box.get(widget.project.documentId)];
            var boxKeys = box.keys;
            for (var k in boxKeys) {
              if (box.get(k) > 0 && !keys.contains(k)) {
                keys.add(k);
                valuesInt.add(box.get(k));
              }
            }
            List<double> values = [];
            for (int i in valuesInt) {
              values.add(i.toDouble());
            }

            List<Widget> otherProjects = [];
            for (int i=2; i<keys.length; i++) {
              otherProjects.add(_projectItem(
                  keys[i], Hive.box('keyToName').get(keys[i]) ?? "x", _colors[i], FontWeight.normal));
            }

            Widget col = Column(children: otherProjects,);

            return Column(
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                _myBudget(Theme.of(context).primaryColor),
                _projectItem(
                    widget.project.documentId ?? "", widget.project.name, Theme.of(context).accentColor, FontWeight.bold),
                col,
                Container(
                  width: 400,
                  height: 400,
                  child: PieChart(
                    PieChartData(
                        pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections:
                        showingSections(values.length, _colors, values)),
                  ),
                ),
              ],
            );
          },
        )
      ),
    );
  }

  Widget _projectItem(String id, String name, Color color, FontWeight fontWeight) {
    var box = Hive.box('budget');
    if (box.get(id) == null || box.get(id) == 0)
      box.put(id, 0);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 190,
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: fontWeight),
            ),
          ),
          Spacer(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: color,
            child: Column(
              children: <Widget>[
                Card(
                  child: Text(
                    box.get(id).toString() + " \$",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 27,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (box.get('wallet') >= 1) {
                            box.put(id, box.get(id) + 1);
                            box.put('wallet', box.get('wallet') - 1);
                          }
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 27,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (box.get(id) >= 1) {
                            box.put(id, box.get(id) - 1);
                            box.put('wallet', box.get('wallet') + 1);
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 1,
          ),
        ],
      ),
    );
  }

  Widget _myBudget(Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "My Wallet",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Spacer(),
          Card(
            color: Colors.white,
            child: Text(
              Hive.box('budget').get('wallet').toString() + " \$",
              style: TextStyle(fontSize: 19),
            ),
          ),
          SizedBox(
            height: 45,
            width: 27,
          ),
        ],
      ),
    );
  }



  List<PieChartSectionData> showingSections(
      int size, List<Color> colors, List<double> percents) {
    return List.generate(size, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: colors[i],
        value: percents[i],
        title: percents[i].roundToDouble().toString(),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );

    });
  }
}
