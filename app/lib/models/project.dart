import 'dart:developer' as dev;
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
  String? image;
  //final Location location;
  GeoPoint? location;
  Stage stage;
  List<Proposal> proposals;

  bool sustainability = true;
  bool education = false;
  bool culture = false;

  List<String> upVotes = [];
  List<String> downVotes = [];
  int funding = 0;

  int cost = -1;


  Project(this.documentId, this.name, this.description, this.image, this.stage, this.proposals, this.location, this.sustainability, this.education, this.culture, this.cost, [ this.richtext, upVotes, downVotes]) {
    this.upVotes = upVotes ?? [];
    this.downVotes = downVotes ?? [];
  }

  Future<void> save(String name, String description, GeoPoint? location, String? richtext, String? image) async {
    final projectsDb = FirebaseFirestore.instance.collection("projects");
    this.name = name;
    this.description = description;
    this.location = location;
    this.richtext = richtext;

    var value = {
      "name": name,
      "description": description,
      "richtext": richtext,
      "image": image,
      "location": location
    };

    if(documentId != null) {
      return await projectsDb.doc(documentId).update(value);
    } else {
      var res = await projectsDb.add(value);
      this.documentId = res.id;
    }
  }

  Future<void> updateVotes() {
    final projectsDb = FirebaseFirestore.instance.collection("projects");
    return projectsDb.doc(documentId).update({
      "upVotes": upVotes,
      "downVotes": downVotes
    });
  }

  static Project mapDocumentToProject(DocumentSnapshot docFull) {
    var doc = docFull.data();
    return Project(
        docFull.id,
        doc!['name'],
        doc['description'],
        doc['image'],
        Stage.initial,
        [],
        doc['location'],
        doc['sustainability'] ?? false,
        doc['education'] ?? false,
        doc['culture'] ?? false,
        doc['cost'] ?? -1,
        doc['richtext'],
        ((doc['upVotes'] ?? []) as List).cast<String>().toList(),
        ((doc['downVotes'] ?? []) as List).cast<String>().toList()
    );
  }
}

List<Project> generateDummyProjects(){
  return List.generate(20, (i) => new Project("xxxxx$i", "dummy $i", "blujil kj kjh jh jhg jhfhgfjhk uo iu ou oi uo uiiuouoiu ui jkh jkh gjhghgfhgfghfhgf g fhfhgfhfhfhfgf yui yiu oyu yui yiuy io u yoiuyi y iy iy b $i", "", Stage.denied, [], GeoPoint(47.404629 + Random().nextDouble()*1e-2, 8.503784 + Random().nextDouble()*1e-2), false, false, false, -1));
}