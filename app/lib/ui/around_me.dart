import 'dart:async';
import 'dart:developer';

import 'package:app/models/project.dart';
import 'package:app/ui/project_page.dart';
import 'package:app/utils/map/map_helper.dart';
import 'package:app/utils/map/map_marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../utils/locationHelper.dart' as loc;

Marker getCustomMarker(Project project, BitmapDescriptor? icon, void Function(String) cb) {
  return Marker(
      markerId: MarkerId(project.documentId ?? "newid"),
      position: LatLng(project.location?.latitude ?? 0, project.location?.longitude ?? 0),
      infoWindow: InfoWindow(
        title: project.name
      ),
      icon: icon ?? BitmapDescriptor.defaultMarker,
    onTap: ()=>cb(project.documentId ?? "newid")
  );
}

class AroundMe extends StatefulWidget {
  @override
  _AroundMeState createState() => _AroundMeState(); //TODO add consumer
}

class _AroundMeState extends State<AroundMe> {
  final Completer<GoogleMapController> _controller = Completer();
  Project? selectedProject;

  BitmapDescriptor? icon;

  void setIcon(BitmapDescriptor newIcon) {
    setState(() {
      icon = newIcon;
    });
  }

  _AroundMeState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "assets/images/marker.png")
          .then(setIcon)
          .catchError((e){log(e.toString());});
  }

  void handleMarkerSelect(String documentId, List<Project> projects) {
    setState(() {
      selectedProject = projects.firstWhere((element) => element.documentId == documentId);
    });
  }

  @override
  void initState() {
    super.initState();
    _gotoCurrentLocation();
  }

  void mapOnTap(LatLng position) {
    setState(() {
      selectedProject = null;
    });
  }

  Widget getMap(List<Project> projects) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPos,
      markers: Set.from(projects.map((p)=>getCustomMarker(p, icon, (String docId)=>handleMarkerSelect(docId, projects)))),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: mapOnTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      compassEnabled: true,
    );
  }

  void openProjectDetails() {
    if(selectedProject == null) {
      return;
    }
    Navigator.push(context,
      MaterialPageRoute(builder: (context)=>ProjectPage(project: selectedProject!))
    );
  }

  Widget getInfoPanel() {
    return AnimatedPositioned(
          left: 0.0,
          right: 0.0,
          bottom: 40,
          duration: Duration(milliseconds: 200),
          child: Container(
            width: 100,
            height: 250,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5),
                    )],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text("${selectedProject!.downVotes + selectedProject!.upVotes}", style: TextStyle(color: Colors.white, fontSize: 20),),
                        minRadius: 20,
                        maxRadius: 25,
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: openProjectDetails,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.fromLTRB(0, 15, 5, 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    selectedProject?.name ?? "No marker selected",
                                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                    selectedProject?.description ?? "No description available",
                                    maxLines: 2, overflow: TextOverflow.ellipsis
                                  )
                                ]
                            )
                          )
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                        child: Icon(Icons.grade_rounded, color: Colors.yellow, size: 50,),
                    )
                  ],
                ),
              ),
            )
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("projects").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {
            var projects = snapshot.data!.docs.map(Project.mapDocumentToProject).toList();
            log("Number of projects: ${projects.length}");
            log("Number of projects: ${projects[0].location!.longitude}");
            return getMainContent(context, projects);
          }
          if(snapshot.hasError) {
            return Text("Error!");
          }

          return Text("Loading....");
        }
    );
  }

  Widget getMainContent(BuildContext context, List<Project> projects) {
    return new Scaffold(
      body: Stack(
        children: [
          getMap(projects),
          if(selectedProject != null) getInfoPanel(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoCurrentLocation,

        child: Icon(Icons.gps_fixed, color: Colors.black,),
        elevation: 1.0,
        mini: true,
        //shape: RoundedRectangleBorder(),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  static final CameraPosition _initialPos = CameraPosition(
    target: LatLng(47.377220, 	8.539902),
    zoom: 5,
  );


  Future<void> _gotoCurrentLocation() async {
    LocationData _location = await loc.getLocation();
    final CameraPosition _locationPos = CameraPosition(
        target: LatLng(_location.latitude ?? 0, _location.longitude ?? 0),
        zoom: 14);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_locationPos));
  }
}
