import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/fund_project.dart';
import 'package:app/utils/thumbs_up_down.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {

  Image displayImage(String url) {
    return Image.network(url, fit: BoxFit.cover, height: 200,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text(widget.project.name),
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor, Theme.of(context).accentColor]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(
              child: displayImage(widget.project.image ?? ""),
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 3.0,
            ),
            SizedBox(height: 7,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 15,),
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
                            builder: (context) => FundProject(project: widget.project, userModel: UserModel(),)));
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
                SizedBox(width: 20,),
                ThumbsUpDown(),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 7,),
             Row(
                children: <Widget>[
                  Expanded(
                  child: Container(width: 50,),
                  ),
                  Expanded(child: Text(widget.project.description, textAlign: TextAlign.center,)),
                ],
              ),
            Center(child: Text(widget.project.description, textAlign: TextAlign.center,),),
            SizedBox(height: 50,),

            TextButton(
              child: Text(
                "Make an offer",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18),
              ),
              onPressed: () {

              },),




          ],
        ),
      ),

    );
  }
}

