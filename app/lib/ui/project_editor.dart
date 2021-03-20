import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zefyr/zefyr.dart';

class ProjectEditor extends StatefulWidget {
  @override 
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ZefyrController? _rtController;
  FocusNode? _focusNode;
  bool rtHasFocus = false;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _rtController = ZefyrController(document);
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      setState(() {
        rtHasFocus = !rtHasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new issue"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save_rounded,
              color: Colors.white
            ),
            onPressed: () {

            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 0),
          ),
          child:
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                     child:
                        SingleChildScrollView(
                          child: Column(
                            children: [
                               Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: Form(
                                      child: Column(
                                        children: [
                                           TextFormField(
                                             style: TextStyle(fontSize: 25),
                                             decoration: InputDecoration(
                                               hintText: "Enter a title",
                                               labelText: "Issue title",
                                               labelStyle: TextStyle(fontSize: 20)
                                             ),
                                           ),
                                           TextFormField(
                                             style: TextStyle(fontSize: 20),
                                             decoration: InputDecoration(
                                                 hintText: "Enter a short description",
                                                 labelText: "Short description",
                                                 labelStyle: TextStyle(fontSize: 18)
                                             ),
                                           ),
                                        ],
                                      ),
                                    ),
                              ),
                              ZefyrField(
                                controller: _rtController,
                                focusNode: _focusNode,
                                autofocus: false,
                                // readOnly: true,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                //onLaunchUrl: _launchUrl,
                              ),
                          ]
                        )
                     )
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 50,
                    width: double.infinity,
                    child: Visibility(
                      visible: rtHasFocus,
                      child: getControls(),
                    )
                  )
                )],
            ),
        ),
      ),
    );
  }

  Widget getControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleStyleButton(
          attribute: NotusAttribute.bold,
          icon: Icons.format_bold,
          controller: _rtController,
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.italic,
          icon: Icons.format_italic,
          controller: _rtController,
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.underline,
          icon: Icons.format_underline,
          controller: _rtController,
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.strikethrough,
          icon: Icons.format_strikethrough,
          controller: _rtController,
        ),
        VerticalDivider(
            indent: 16, endIndent: 16, color: Colors.grey.shade400
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.block.numberList,
          controller: _rtController,
          icon: Icons.format_list_numbered,
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.block.bulletList,
          controller: _rtController,
          icon: Icons.format_list_bulleted,
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.block.code,
          controller: _rtController,
          icon: Icons.code,
        ),
        VerticalDivider(
            indent: 16, endIndent: 16, color: Colors.grey.shade400
        ),
        ToggleStyleButton(
          attribute: NotusAttribute.block.quote,
          controller: _rtController,
          icon: Icons.format_quote,
        ),
        VerticalDivider(
            indent: 16, endIndent: 16, color: Colors.grey.shade400
        ),
        InsertEmbedButton(
          controller: _rtController,
          icon: Icons.horizontal_rule,
        ),
      ],
    );
  }
  Widget getBasicForm() {
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Enter a title'),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter a short description'
              ),
            )
          ],
        )
    );
  }

  NotusDocument _loadDocument() {
    final json =
        r'[{"insert":"Enter details here"},{"insert":"\n","attributes":{"heading":2}},{"insert":{"_type":"hr","_inline":false}},{"insert":"\n"},{"insert":"Multiple format options are available\n"}]';
    final document = NotusDocument.fromJson(jsonDecode(json));
    return document;
  }
}