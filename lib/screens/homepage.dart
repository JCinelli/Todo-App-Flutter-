import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/database_helper.dart';
import 'package:todoApp/screens/taskpage.dart';
import 'package:todoApp/widgets.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color(0xFF812DE3),
      Color(0xFFEB1294),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 32.0,
                        bottom: 40.0,
                      ),
                      child: Text(
                        "To Do",
                        style: TextStyle(
                          fontSize: 55.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.findAllTasks(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data.length != null
                              ? snapshot.data.length
                              : 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Taskpage(
                                      currentTask: snapshot.data[index],
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: TaskcardWidget(
                                title: snapshot.data[index].title,
                                description: snapshot.data[index].description,
                              ),
                            );
                          },
                          physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                                currentTask: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2C2D2E),
                            Color(0xFF2C2D2E),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Image(
                      image: AssetImage('assets/images/add_icon.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
