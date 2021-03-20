import 'package:app/models/proposal.dart';
import 'package:flutter/cupertino.dart';

enum Stage {
  initial, proposals, accepted, denied
}

class Project {
  final String name;
  final String description;
  final AssetImage image;
  //final Location location;
  final Stage stage;
  final List<Proposal> proposals;

  Project(this.name, this.description, this.image, this.stage, this.proposals);
}