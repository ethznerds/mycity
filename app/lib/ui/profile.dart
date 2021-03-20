import 'dart:developer';

import 'package:app/models/app_state.dart';
import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, child) =>
        appState.isLoggedIn() ? _ProfileWidget(signOut: appState.signOut, userDisplayName: FirebaseAuth.instance.currentUser!.displayName ?? "",) : Login(
          email: appState.email,
          loginState: appState.loginState,
          startLoginFlow: appState.startLoginFlow,
          verifyEmail: appState.verifyEmail,
          signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
          cancelRegistration: appState.cancelRegistration,
          registerAccount: appState.registerAccount,
          signOut: appState.signOut,
          errorMsg: appState.errorMsg,
        )
    );
  }
}
class _ProfileWidget extends StatefulWidget{
  final void Function() signOut;
  final String userDisplayName;

  const _ProfileWidget({
    required this.signOut,
    required this.userDisplayName
  });

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}
class _ProfileWidgetState extends State<_ProfileWidget> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //TODO Fetch things here? https://stackoverflow.com/questions/51378641/how-to-build-dynamic-list-from-http-server-in-flutter/51388537
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Profile avatar
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    getAvatar(),
                    Expanded(child: Padding(padding: EdgeInsets.only(left:20), child: logoutWidget(),)),
                ]
              ),
              SizedBox(height: 20,),
              Text(widget.userDisplayName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
              SizedBox(height: 20,),
              userAchievements(),
              SizedBox(height: 20,),
              getProjects()
            ],
          ),
        ),
    );
  }

  void _logout() {
    widget.signOut();
  }

  Widget getProjects() {
    var dummyProjects = generateDummyProjects();
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: TabBar(tabs: [
                Tab(text: "Ongoing projects",),
                Tab(text: "Past projects",)
              ],
              indicatorColor: Colors.deepPurpleAccent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black26,)
            ),
            Container(
              height: 300,
              child:
                Align(
                  alignment: Alignment.topCenter,
                  child: TabBarView(children: [
                    buildProjectListView(dummyProjects),
                    buildProjectListView(dummyProjects),
                  ])
                )
            )
          ],
        ),
      )
    );
  }

  Widget buildProjectListView(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(projects[index].name),
          subtitle: Text(projects[index].description, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {/*TODO open project */},
        );
      },
      controller: _scrollController,
    );
  }

  Widget userAchievements() {
    const numberStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.deepPurpleAccent);
    const textStyle = TextStyle(fontSize: 15);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 2.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("120", style: numberStyle,),
                      Text("Contributions", style: textStyle)
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text("9", style: numberStyle),
                      Text("Issues filed", style: textStyle)
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text("3238", style: numberStyle),
                      Text("People reached", style: textStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/hero_icon.jpg'),
                    minRadius: 28,
                  ),
                  Text("1829 Karma"),
                ],
              ),
              SizedBox(width: 20,),
              Text("Local hero", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
            ],
          ),
        ],
      ),
    );
  }

  Widget getAvatar() {
    // TODO user image
    if(false) {
      return CircleAvatar(
        backgroundImage: NetworkImage("https://i.pinimg.com/474x/4e/3e/f4/4e3ef43feefd867c0969e0ff6fb46bef.jpg"),
      );
    }

    // Get initials
    String initials = "XX";
    if(widget.userDisplayName.isNotEmpty) {
      var parts = widget.userDisplayName.split(" ");
      initials = parts[0].substring(0,1) + parts[parts.length - 1].substring(0,1);
      initials = initials.toUpperCase();
    }
    return CircleAvatar(
      backgroundColor: Colors.blueAccent,
      child: Text(initials, style: TextStyle(color: Colors.white, fontSize: 60),),
      minRadius: 60,
    );
  }

  Widget logoutWidget() {
    return InkWell(
      onTap: this._logout,
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
        decoration: BoxDecoration(
            color: Colors.transparent
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: 30,
              ),
              Text("Logout"),
            ]
          )
        ),
      ),
    );
  }
}
