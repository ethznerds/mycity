import 'package:app/data/some_projects.dart';
import 'package:app/ui/project_item.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  final itemsList = List<String>.generate(projects.length - 1, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return generateItemsList();
  }

  ListView generateItemsList() {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(index.toString()),
          child: InkWell(
              onTap: () {
              },
              child: ProjectItem(
                project: projects[index],
              )),
          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
          confirmDismiss: (direction) async {
            //DOWN
            if (direction == DismissDirection.endToStart) {


              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  itemsList.removeAt(index);
                });
              });
              /*final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                          "Are you sure you want to delete ${itemsList[index]}?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // TODO: Delete the item from DB etc..
                            setState(() {
                              itemsList.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              return res;*/
            } else {
              // TODO: Navigate to edit page;
            }
          },
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.thumb_up,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Approve",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Disapprove",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.thumb_down,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

}
