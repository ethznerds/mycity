import 'package:app/models/project.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.project.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(
              child: Image(image: widget.project.image,fit: BoxFit.cover),
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
                    "buy",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18),
                  ),
                  onPressed: () {},
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


          ],
        ),
      ),

    );
  }
}

