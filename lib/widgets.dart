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
              /* If 'title' is null, write 'No title added . .' */
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

class TodoWidget extends StatelessWidget {
  /* Fields */
  final String text;
  final bool isDone;

  TodoWidget({this.text, this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone
                  ? null
                  : Border.all(color: Color(0xFF86829D), width: 1.5),
            ),
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Text(
            text ?? '(Unnamed Todo)',
            style: TextStyle(
                fontSize: 16.0,
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
