import 'dart:math';

import 'package:app/models/proposal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum Stage {
  initial, proposals, accepted, denied
}

class Project {
  String? documentId;
  String name;
  String description;
  String? richtext;
  AssetImage? image;
  //final Location location;
  GeoPoint? location;
  Stage stage;
  List<Proposal> proposals;

  int upVotes = 0;
  int downVotes = 0;
  int funding = 0;


  Project(this.documentId, this.name, this.description, this.image, this.stage, this.proposals, this.location, [this.richtext]);

  Future<void> save(String name, String description, GeoPoint? location, String? richtext) async {
    final projectsDb = FirebaseFirestore.instance.collection("projects");
    this.name = name;
    this.description = description;
    this.location = location;
    this.richtext = richtext;

    var value = {
      "name": name,
      "description": description,
      "richtext": richtext,
    };

    if(documentId != null) {
      return await projectsDb.doc(documentId).update(value);
    } else {
      var res = await projectsDb.add(value);
      this.documentId = res.id;
    }
  }
}

List<Project> generateDummyProjects(){
  return List.generate(20, (i) => new Project("xxxxx$i", "dummy $i", "blujil kj kjh jh jhg jhfhgfjhk uo iu ou oi uo uiiuouoiu ui jkh jkh gjhghgfhgfghfhgf g fhfhgfhfhfhfgf yui yiu oyu yui yiuy io u yoiuyi y iy iy b $i", AssetImage(""), Stage.denied, [], GeoPoint(47.404629 + Random().nextDouble()*1e-2, 8.503784 + Random().nextDouble()*1e-2)));
}