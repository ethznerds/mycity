import 'dart:math';

import 'package:app/models/proposal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum Stage {
  initial, proposals, accepted, denied
}

class Project {
  final String documentId;
  final String name;
  final String description;
  final AssetImage image;
  //final Location location;
  GeoPoint? location;
  final Stage stage;
  final List<Proposal> proposals;

  int upVotes = 0;
  int downVotes = 0;
  int funding = 0;


  Project(this.documentId, this.name, this.description, this.image, this.stage, this.proposals, this.location);
}

List<Project> generateDummyProjects(){
  return List.generate(20, (i) => new Project("xxxxx$i", "dummy $i", "blujil kj kjh jh jhg jhfhgfjhk uo iu ou oi uo uiiuouoiu ui jkh jkh gjhghgfhgfghfhgf g fhfhgfhfhfhfgf yui yiu oyu yui yiuy io u yoiuyi y iy iy b $i", AssetImage(""), Stage.denied, [], GeoPoint(47.404629 + Random().nextDouble()*1e-2, 8.503784 + Random().nextDouble()*1e-2)));
}