import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/models/project.dart';
import 'package:app/utils/locationHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image/image.dart' as ImageLibrary;
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:zefyr/zefyr.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class ProjectEditor extends StatefulWidget {

  final Project project;

  ProjectEditor(this.project);

  @override 
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final projectsDb = FirebaseFirestore.instance.collection("projects");
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final imagePicker = ImagePicker();
  late AnimationController animController;
  File? _image;
  PickResult? pickedPlace;

  ZefyrController? _rtController;
  FocusNode? _focusNode;
  bool rtHasFocus = false;
  bool showSpinner = false;
  String? documentId;

  _ProjectEditorState({
    this.documentId
  });

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    animController.repeat(reverse: true);
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

  Future<String> prepareImageForUpload(File file) async {
    var image = ImageLibrary.decodeImage(file.readAsBytesSync());
    if(image == null) return "";
    var thumbnail = ImageLibrary.copyResize(image, width: 720);
    // return base64Encode(ImageLibrary.encodeJpg(thumbnail, quality: 50));
    var storageReference = fbs.FirebaseStorage.instance
      .ref()
      .child("images")
      .child('/${getRandomString(30)}.jpg');
    final metadata = fbs.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    var uploadTask = storageReference.putData(Uint8List.fromList(ImageLibrary.encodeJpg(thumbnail, quality: 70)), metadata);
    var result = await uploadTask;
    return result.ref.getDownloadURL();
  }

  void pickPlace(BuildContext context) {
      Navigator.push(context,
        MaterialPageRoute(
            builder: (context)=>PlacePicker(
                apiKey: "AIzaSyB6LLJta03nFMx0ZIOqa85OZKNsjKrFnc8",
                initialPosition: LatLng(0.0, 0.0),
                useCurrentLocation: true,
                onPlacePicked: (result) {
                  setState(() {
                    pickedPlace = result;
                    addressController.text = result.formattedAddress ?? "";
                  });
                  Navigator.of(context).pop();
                },
            )
        )
      );
  }

  void saveEntry() async {
    setState(() {
      showSpinner = true;
    });
    widget.project.save(
        titleController.text,
        descriptionController.text,
        pickedPlace == null ? null : GeoPoint(pickedPlace!.geometry!.location.lat, pickedPlace!.geometry!.location.lng),
        jsonEncode(_rtController!.document),
        _image == null ? null : await prepareImageForUpload(_image!)
    ).then((value) {
      setState(() {
        showSpinner = false;
      });
    }).catchError((e){
      dev.log("xxx error occurred");
      setState(() {
        showSpinner = false;
      });
    });
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        dev.log("No file selected");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text("Create a new issue"),
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor, Theme.of(context).accentColor]),
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
                                             controller: titleController,
                                             decoration: InputDecoration(
                                               hintText: "Enter a title",
                                               labelText: "Issue title",
                                               labelStyle: TextStyle(fontSize: 20)
                                             ),
                                           ),
                                           TextFormField(
                                             style: TextStyle(fontSize: 20),
                                             controller: descriptionController,
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
                              SizedBox(height: 10,),
                              if(_image == null) ElevatedButton.icon(
                                  onPressed: getImage,
                                  icon: Icon(
                                    Icons.image_outlined
                                  ),
                                  label: Padding(
                                    padding: EdgeInsets.all(10),
                                      child:Text("Add image", style: TextStyle(fontSize: 20),)
                                  )
                              ),
                              if(_image != null) Image.file(_image!, height: 150,),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  onTap: ()=>pickPlace(context),
                                  controller: addressController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Click here to add an address"
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
                              if(!showSpinner) ElevatedButton(
                                onPressed: saveEntry,
                                child: Text("Save issue"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
                              ),
                              if(showSpinner) CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
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