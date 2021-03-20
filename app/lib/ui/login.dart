import 'dart:developer';

import 'package:app/models/user.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/collab.jpg'),
                    fit: BoxFit.fill
                  )
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
              child: Column(
                children: <Widget>[
                  Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      )
                  ),
                  SizedBox(height: 13,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or User name",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: this._doLogin,
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
                        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),

                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                  SizedBox(height: 10,),
                  Text("No account yet? Click here to sign up!", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
                ],
              ),
            )
            ],
          )
        ),
      )
    );
  }
}
