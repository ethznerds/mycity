import 'dart:developer';

import 'package:app/models/user.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void _doLogin() {
    //TODO do login
    UserModel().setUser("Hans", "Tester");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Not yet signed in",
                  style: TextStyle(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  )
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                  child: Center(
                    child: Text("Go to login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
