import 'dart:developer';

import 'package:app/models/app_state.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/login.dart';
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
        appState.isLoggedIn() ? _ProfileWidget(signOut: appState.signOut) : Login(
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

  const _ProfileWidget({
    required this.signOut
  });

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}
class _ProfileWidgetState extends State<_ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              logoutWidget(),
            ],
          ),
        ),
    );
  }

  void _logout() {
    widget.signOut();
  }

  Widget logoutWidget() {
    return InkWell(
      onTap: this._logout,
      child: Container(
        height: 50,
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
