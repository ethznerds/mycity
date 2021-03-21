import 'package:app/models/project.dart';
import 'package:app/models/proposal.dart';
import 'package:flutter/material.dart';

List<Proposal> _proposals1 = [
 Proposal("A Copmany", "lala", 2000.50),
];

List<Project> projects = [
 Project("adfadf", "New Playground", "Build a small playground next to the primary school. Build a small playground next to the primary school. Build a small playground next to the primary school.", "", Stage.proposals, _proposals1, null, false, false, false, -1),
 Project("badsfa", "Pothole at Zwergenschiff", "Pothole in Helen-Keller-Strasse has to be fixed.", "", Stage.initial, _proposals1, null, false, false, false, -1),
 Project("gdsgdg", "Solar Panels for Schule Fluntern", "Add Solar Panels to the roof of Schule Fluntern.","", Stage.proposals, _proposals1, null, true, false, false, -1),
];




