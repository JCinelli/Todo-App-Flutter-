import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todoApp/database_helper.dart';
import 'package:todoApp/models/task.dart';
import 'package:todoApp/models/todo.dart';
import 'package:todoApp/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task currentTask;

  Taskpage({@required this.currentTask});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String currentTaskTitle = "";
  int currentTaskId = 0;

  @override
  void initState() {
    if (widget.currentTask != null) {
      this.currentTaskTitle = widget.currentTask.title;
      this.currentTaskId = widget.currentTask.id;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              /* Check if the value is empty */
                              if (value != "") {
                                /* Check if the task is null */
                                if (widget.currentTask == null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newTask = Task(title: value);
                                  await _dbHelper.insertTask(_newTask);
                                  print('New task has been created !');
                                } else {
                                  print('Update the existing task !');
                                }
                              }
                            },
                            controller: TextEditingController()
                              ..text = this.currentTaskTitle,
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551)),
                            decoration: InputDecoration(
                              hintText: 'Enter task title',
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter description for the task',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24.0)),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbHelper.findAllTodos(currentTaskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: TodoWidget(
                                text: snapshot.data[index].title,
                                isDone: snapshot.data[index].isDone == 0
                                    ? false
                                    : true,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                                color: Color(0xFF86829D), width: 1.5),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/check_icon.png'),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          onSubmitted: (value) async {
                            /* Check if the value is empty */
                            if (value != "") {
                              /* Check if the task is null */
                              if (widget.currentTask != null) {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: widget.currentTask.id);
                                await _dbHelper.insertTodo(_newTodo);
                                setState(() {});
                                print('New todo has been created !');
                              } else {
                                print('Update the existing todo !');
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter todo item . .',
                            border: InputBorder.none,
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Taskpage()),
                    );
                  },
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Image(
                      image: AssetImage('assets/images/delete_icon.png'),
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
