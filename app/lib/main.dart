import 'package:app/models/app_state.dart';
import 'package:app/models/project.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/profile.dart';
import 'package:app/ui/around_me.dart';
import 'package:app/ui/project_editor.dart';
import 'package:app/ui/vote.dart';
import 'package:app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:provider/provider.dart'; // new
import 'utils/authentication.dart'; // new
import 'dart:async'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('vote');
  await Hive.openBox('budget');
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => ApplicationState()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text("Error",  textDirection: TextDirection.ltr);
          }

          if(snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                // primaryColor: Color.fromARGB(255, 127, 40, 198),
                // accentColor: Colors.teal,127
                primaryColor: Color.fromARGB(255, 0, 131, 52),
                accentColor: Color(0xFF587cc7),
              ),
              home: MyHomePage(title: 'VoteUp'),
            );
          }

          return Text("Loading...",  textDirection: TextDirection.ltr);
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Vote(),
    AroundMe(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openProjectEditor(Project? project) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=>ProjectEditor(project ?? Project(null, "", "", null, Stage.initial, [], null, false, false, false, -1)))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("voteUp"),
      // ),
      appBar: NewGradientAppBar(
        title: Text("mycity"),
        gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor, Theme.of(context).accentColor]),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: ()=>openProjectEditor(null),
        child: const Icon(Icons.add)
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_sharp),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Around Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

///FIREBASE

class GuestBook extends StatefulWidget {
  GuestBook({required this.addMessage});
  final Future<void> Function(String message) addMessage;

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Leave a message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your message to continue';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 8),
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.addMessage(_controller.text);
                  _controller.clear();
                }
              },
              child: Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 4),
                  Text('SEND'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
