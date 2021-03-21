import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/fund_project.dart';
import 'package:app/utils/thumbs_up_down.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:zefyr/zefyr.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ZefyrController? _rtController;
  FocusNode? _focusNode;

  Image displayImage(String url) {
    return Image.network(url, fit: BoxFit.cover, height: 250,);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument(widget.project);
    _rtController = ZefyrController(document);
    _focusNode = FocusNode();
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
            SizedBox(height: 15,),
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
                ThumbsUpDown(project: widget.project,),
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
            SizedBox(height: 15,),
            Center(child: Text(widget.project.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),),
            SizedBox(height: 15,),
            ZefyrField(
              controller: _rtController,
              focusNode: _focusNode,
              autofocus: false,
              readOnly: true,
              padding: EdgeInsets.only(left: 16, right: 16),
              //onLaunchUrl: _launchUrl,
            ),
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
  NotusDocument _loadDocument(Project project) {
    final json =
        r'[{"insert":"No further details provided\n"}]';
    final document = NotusDocument.fromJson(jsonDecode(project.richtext ?? json));
    return document;
  }
}

