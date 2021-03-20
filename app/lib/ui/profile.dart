import 'dart:developer';

import 'package:app/models/app_state.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Profile avatar
            getAvatar(),
            SizedBox(height: 20,),
            Text(widget.userDisplayName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
            SizedBox(height: 20,),
            userAchievements(),
            Spacer(),
            logoutWidget(),
          ],
        ),
    );
  }

  void _logout() {
    widget.signOut();
  }

  Widget userAchievements() {
    const numberStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.deepPurpleAccent);
    const textStyle = TextStyle(fontSize: 15);
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 2.0)
      ),
      child: Column(
        children: <Widget>[
          Row(
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
          )
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
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ]
            )
        ),
        child: Center(
          child: Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
