import 'dart:developer';

import 'package:app/models/user.dart';
import 'package:app/utils/authentication.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  const Login({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
    required this.errorMsg,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final String? errorMsg;
  final void Function() startLoginFlow;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) verifyEmail;
  final void Function(
      String email,
      String password,
      void Function(Exception e) error,
      ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
      String email,
      String displayName,
      String password,
      void Function(Exception e) error,
      ) registerAccount;
  final void Function() signOut;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController displayNameController = new TextEditingController();

  void _buttonClicked() {
    if(widget.loginState == ApplicationLoginState.password) {
      log("Password state");
      widget.signInWithEmailAndPassword(
          usernameController.text.trim(), passwordController.text.trim(), (e) =>
      {
        log("Failed to sign in with email and password")
      });
    } else if(widget.loginState == ApplicationLoginState.register) {
      widget.registerAccount(
        usernameController.text.trim(),
        displayNameController.text.trim(),
        passwordController.text.trim(),
        (e)=>{
          log("Failed to create account ${e.toString()}"),
        }
      );
    }
    else {
      log("Email state");
      widget.verifyEmail(usernameController.text.trim(), (e)=>{
        log("Failed to verify email address"),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.errorMsg ?? "empty error msg");
    String buttonText = "Next";
    if(widget.loginState == ApplicationLoginState.password) {
      buttonText = "Login";
    } else if(widget.loginState == ApplicationLoginState.register) {
      buttonText = "Sign up";
    }
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
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!))
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
                        if (widget.loginState == ApplicationLoginState.register) Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                          ),
                          child: TextField(
                            controller: displayNameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter display name",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        if (widget.loginState == ApplicationLoginState.password || widget.loginState == ApplicationLoginState.register) Container(
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
                        ),
                        if (widget.errorMsg?.isNotEmpty ?? false) Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            widget.errorMsg ?? "",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: this._buttonClicked,
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
                        child: Text(buttonText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),

                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
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
