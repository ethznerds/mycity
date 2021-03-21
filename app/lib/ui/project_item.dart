import 'dart:developer';

import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/fund_project.dart';
import 'package:app/ui/fund_project2.dart';
import 'package:app/ui/project_page.dart';
import 'package:app/utils/thumbs_up_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProjectItem extends StatefulWidget {
  final Project project;

  const ProjectItem({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectPage(
                      project: widget.project,
                    )));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  widget.project.name != "Renovation of Historical Museum"
                      ? Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orange,
                        )
                      : Icon(
                          Icons.article_outlined,
                          color: Colors.brown,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.project.name == "Paper and Carton Collection"
                      ? Icon(
                          Icons.spa_outlined,
                          color: Colors.green,
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Expanded(child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.project.name,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.project.description,
                        softWrap: true,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            child: Text(
                              "fund",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FundProject(
                                            project: widget.project,
                                            userModel: UserModel(),
                                          )));
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(11.0),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)))),
                          ),
                          Spacer(),
                          thumbsWrapper(),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

/*        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Column(
                children: <Widget>[
                  //widget.project.stage == Stage.initial ? Icon(Icons.lightbulb_outline) : Icon(Icons.article_outlined),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text((widget.project.upVotes + widget.project.downVotes).toString()),
                      SizedBox(width: 10,),

                      Icon(Icons.thumbs_up_down_outlined),
                    ],
                  ),

                ],

            ),
              title: Text(widget.project.name),
              subtitle: Text(widget.project.description),
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text("more", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),),
                  onPressed: () {

                  },
                ),

                Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: (){},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: (){},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),*/
        ),
      ),
    );
  }
  Widget thumbsWrapper() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("projects").doc(widget.project.documentId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasData) {
            var project = Project.mapDocumentToProject(snapshot.data!);
            return ThumbsUpDown(project: project,);
          }

          if(snapshot.hasError) {
            return Text("Error!");
          }

          return Text("Loading....");
        }
    );
  }
}
