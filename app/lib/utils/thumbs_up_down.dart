import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

enum upDownOrNone {
  none, up, down,
}

class ThumbsUpDown extends StatefulWidget {
  final Project project;

  const ThumbsUpDown({Key? key, required this.project}) : super(key: key);

  @override
  _ThumbsUpDownState createState() => _ThumbsUpDownState();
}

class _ThumbsUpDownState extends State<ThumbsUpDown> {
  Box<dynamic> _box = Hive.box('vote');

  @override
  void initState() {
    _box = Hive.box('vote');
    if (_box.get(widget.project.documentId) == null)
      _box.put(widget.project.documentId, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (context, cart, child) => Container(
          width: 100,
          height: 40,
          child: Row(
            children: <Widget>[
              getThumbButton(Icons.thumb_up, 1, Colors.green, widget.project),
              SizedBox(width: 10,),
              getThumbButton(Icons.thumb_down, -1, Colors.red, widget.project),
            ],
          ),
        ),
    );
  }
  getThumbButton(IconData iconData, int add, Color activeColor, Project project) {
    return ValueListenableBuilder(valueListenable: _box.listenable(),
        builder: (context, box, widget) {
          return InkWell(
            child: Row(
              children: <Widget>[
                Icon(iconData, color: add == _box.get(project.documentId) ? activeColor : Colors.black,),
                Text(add == 1 ? project.upVotes.toString() : project.downVotes.toString(),)
              ],
            ),
            onTap: () {
              if (add == 1) {
                if(add == _box.get(project.documentId)) {
                  project.upVotes--;
                  _box.put(project.documentId, 0);
                } else if (0 == _box.get(project.documentId)) {
                  project.upVotes++;
                  _box.put(project.documentId, 1);
                } else {
                  project.downVotes--;
                  project.upVotes++;
                  _box.put(project.documentId, 1);
                }
              }
              else
                {
                  if(add == _box.get(project.documentId)) {
                    project.downVotes--;
                    _box.put(project.documentId, 0);
                  } else if (0 == _box.get(project.documentId)) {
                    project.downVotes++;
                    _box.put(project.documentId, -1);
                  } else {
                    project.upVotes--;
                    project.downVotes++;
                    _box.put(project.documentId, -1);
                  }

              }
            },
          );;
        });
  }
}
