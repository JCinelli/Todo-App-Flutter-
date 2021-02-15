import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskcardWidget extends StatelessWidget {
  /* Fiels */
  final String title;
  final String description;

  /* Constructor */
  TaskcardWidget({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              /* If 'title' is null, write 'Get started !' */
              title ?? 'No title added . .',
              style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(description ?? 'No description added . .',
                style: TextStyle(
                  color: Color(0xFF868290),
                  fontSize: 16.0,
                  height: 1.5,
                )),
          ),
        ],
      ),
    );
  }
}
