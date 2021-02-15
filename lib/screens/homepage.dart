import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFF6F6F6),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 32.0),
                      child:
                          Image(image: AssetImage('assets/images/logo.png'))),
                  TaskcardWidget(
                    title: 'Get Started !',
                    description:
                        'Hello user ! Welcome to my ToDo app, this is a default task that you can edit or delete to start using the app !',
                  ),
                  TaskcardWidget()
                ],
              ),
              Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        color: Color(0xFF7349FE),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Image(
                      image: AssetImage('assets/images/add_icon.png'),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
