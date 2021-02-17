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
  String currentTaskDesciption = "";
  int currentTaskId = 0;

  FocusNode titleFocus;
  FocusNode descriptionFocus;
  FocusNode todoFocus;

  bool contentVisible = false;

  @override
  void initState() {
    if (widget.currentTask != null) {
      contentVisible = true;

      this.currentTaskTitle = widget.currentTask.title;
      this.currentTaskDesciption = widget.currentTask.description;
      this.currentTaskId = widget.currentTask.id;
    }

    titleFocus = FocusNode();
    descriptionFocus = FocusNode();
    todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    todoFocus.dispose();

    super.dispose();
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
                            focusNode: titleFocus,
                            onSubmitted: (value) async {
                              /* Check if the value is empty */
                              if (value != "") {
                                /* Check if the task is null */
                                if (widget.currentTask == null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newTask = Task(title: value);
                                  this.currentTaskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    contentVisible = true;
                                    currentTaskTitle = value;
                                  });
                                  print('New task has been created !');
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      this.currentTaskId, value);
                                  print('Update the existing task !');
                                }

                                descriptionFocus.requestFocus();
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
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (this.currentTaskId != 0) {
                              await _dbHelper.updateTaskDesciption(
                                  this.currentTaskId, value);
                              this.currentTaskDesciption = value;
                            }
                          }
                          todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = this.currentTaskDesciption,
                        decoration: InputDecoration(
                            hintText: 'Enter description for the task',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.findAllTodos(currentTaskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoIsDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoIsDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
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
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
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
                            focusNode: todoFocus,
                            onSubmitted: (value) async {
                              /* Check if the value is empty */
                              if (value != "") {
                                /* Check if the task is null */
                                if (this.currentTaskId != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: this.currentTaskId,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  print('New todo has been created !');
                                } else {
                                  print('Update the existing todo !');
                                }

                                todoFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController(text: ""),
                            decoration: InputDecoration(
                              hintText: 'Enter todo item . .',
                              border: InputBorder.none,
                            ),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (this.currentTaskId != 0) {
                        await _dbHelper.deleteTask(this.currentTaskId);
                        Navigator.pop(context);
                      }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
