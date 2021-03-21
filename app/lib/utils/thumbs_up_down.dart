import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    var currentUser = FirebaseAuth.instance.currentUser;
    return ValueListenableBuilder(valueListenable: _box.listenable(),
        builder: (context, box, widget) {
          var highlight = false;
          if(currentUser != null) {
            var source = add == 1 ? project.upVotes : project.downVotes;
            highlight = source.contains(currentUser.uid);
          }
          return InkWell(
            child: Row(
              children: <Widget>[
                Icon(iconData, color: highlight ? activeColor : Colors.black,),
                Text(add == 1 ? project.upVotes.length.toString() : project.downVotes.length.toString(),)
              ],
            ),
            onTap: () {
              if(currentUser == null) {
                return;
              }
              if (add == 1) { // upThumb pressed
                if(!project.upVotes.contains(currentUser.uid)) {
                  project.upVotes.add(currentUser.uid);
                } else {
                  project.upVotes.remove(currentUser.uid);
                }
                if(project.downVotes.contains(currentUser.uid)) {
                  project.downVotes.remove(currentUser.uid);
                }
              }
              else {
                if(!project.downVotes.contains(currentUser.uid)) {
                  project.downVotes.add(currentUser.uid);
                } else {
                  project.downVotes.remove(currentUser.uid);
                }
                if(project.upVotes.contains(currentUser.uid)) {
                  project.upVotes.remove(currentUser.uid);
                }
              }
              project.updateVotes();
            },
          );
        });
  }
}
