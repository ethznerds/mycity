import 'package:app/models/project.dart';
import 'package:app/ui/project_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("projects").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            return generateItemsList(
                snapshot.data!.docs.map(Project.mapDocumentToProject).toList()
            );
          }

          if(snapshot.hasError) {
            return Text("Error!");
          }

          return Text("Loading....");
        }
    );
  }

  ListView generateItemsList(List<Project> projects) {
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
                // setState(() {
                //   itemsList.removeAt(index);
                // });
              });

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
