import 'package:app/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProjectItem extends StatefulWidget {
  final Project project;

  const ProjectItem({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: widget.project.stage == Stage.initial ? Icon(Icons.lightbulb_outline) : Icon(Icons.article_outlined),
              title: Text(widget.project.name),
              subtitle: Text(widget.project.description),
            ),
            Image(image: widget.project.image),
            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    icon: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        _isExpanded = ! _isExpanded;
                      });
                    }
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
        ),
        
      ),


    );
  }
}
