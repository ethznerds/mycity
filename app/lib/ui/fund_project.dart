import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

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
  Widget build(BuildContext context) {

    List<Color> _colors = [Theme.of(context).primaryColor, Theme.of(context).accentColor, Colors.grey, Colors.blueGrey];

    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text("Fund " + widget.project.name),
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor, Theme.of(context).accentColor]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 6,),
            _myBudget(Theme.of(context).primaryColor),
            _projectItem(widget.project, Theme.of(context).accentColor, FontWeight.bold),
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
                  sections: showingSections(4, _colors, [20.0, 20.0, 30.0, 30.0])),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectItem(Project project, Color color, FontWeight fontWeight) {
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
              project.name,
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
                    "15 \$",
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
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 27,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
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
              "15 \$",
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

  // Widget getPage() {
  //   return AspectRatio(
  //     aspectRatio: 1.3,
  //     child: Card(
  //       color: Colors.white,
  //       child: Row(
  //         children: <Widget>[
  //           const SizedBox(
  //             height: 18,
  //           ),
  //           Expanded(
  //             child: AspectRatio(
  //               aspectRatio: 1,
  //               child: PieChart(
  //                 PieChartData(
  //                     pieTouchData:
  //                         PieTouchData(touchCallback: (pieTouchResponse) {
  //                       setState(() {
  //                         if (pieTouchResponse.touchInput is FlLongPressEnd ||
  //                             pieTouchResponse.touchInput is FlPanEnd) {
  //                           touchedIndex = -1;
  //                         } else {
  //                           touchedIndex = pieTouchResponse.touchedSectionIndex;
  //                         }
  //                       });
  //                     }),
  //                     borderData: FlBorderData(
  //                       show: false,
  //                     ),
  //                     sectionsSpace: 0,
  //                     centerSpaceRadius: 40,
  //                     sections: showingSections()),
  //               ),
  //             ),
  //           ),
  //           Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: const <Widget>[
  //               Indicator(
  //                 color: Color(0xff0293ee),
  //                 text: 'First',
  //                 isSquare: true,
  //               ),
  //               SizedBox(
  //                 height: 4,
  //               ),
  //               Indicator(
  //                 color: Color(0xfff8b250),
  //                 text: 'Second',
  //                 isSquare: true,
  //               ),
  //               SizedBox(
  //                 height: 4,
  //               ),
  //               Indicator(
  //                 color: Color(0xff845bef),
  //                 text: 'Third',
  //                 isSquare: true,
  //               ),
  //               SizedBox(
  //                 height: 4,
  //               ),
  //               Indicator(
  //                 color: Color(0xff13d38e),
  //                 text: 'Fourth',
  //                 isSquare: true,
  //               ),
  //               SizedBox(
  //                 height: 18,
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             width: 28,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  List<PieChartSectionData> showingSections(int size, List<Color> colors, List<double> percents) {
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
      // switch (i) {
      //   case 0:
      //     return PieChartSectionData(
      //       color: const Color(0xff0293ee),
      //       value: 40,
      //       title: '40%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 1:
      //     return PieChartSectionData(
      //       color: const Color(0xfff8b250),
      //       value: 30,
      //       title: '30%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 2:
      //     return PieChartSectionData(
      //       color: const Color(0xff845bef),
      //       value: 15,
      //       title: '15%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 3:
      //     return PieChartSectionData(
      //       color: const Color(0xff13d38e),
      //       value: 15,
      //       title: '15%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   default:
      //     return PieChartSectionData(
      //       color: const Color(0xff13d38e),
      //       value: 0,
      //       title: '0%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      // }
    });
  }
}
