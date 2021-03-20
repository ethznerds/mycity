import 'package:app/models/project.dart';
import 'package:app/models/proposal.dart';
import 'package:flutter/material.dart';

List<Proposal> _proposals1 = [
 Proposal("A Copmany", "lala", 2000.50),
];

List<Project> projects = [
 Project("adfadf", "New Playground", "Build a small playground next to the primary school. Build a small playground next to the primary school. Build a small playground next to the primary school.", AssetImage('assets/images/playground.jpg'), Stage.proposals, _proposals1, null),
];

