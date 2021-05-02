import 'package:flutter/material.dart';
import 'package:what_todo/widgets/todoitem.dart';

import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  String _taskDescription = "";
  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  final _dbhelper = new DatabaseHelper();

  TextEditingController _todocontroller = new TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      //set visibility to true
      _contentVisible = true;

      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
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
                          onTap: () => {Navigator.pop(context)},
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  _taskId = await _dbhelper.insertTask(
                                    new Task(
                                      title: value,
                                    ),
                                  );
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  await _dbhelper.editTaskTitle(_taskId, value);
                                  setState(() {
                                    _taskTitle = value;
                                  });
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter task title...",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF211551),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        onSubmitted: (value) async {
                          if (value != null) {
                            if (_taskId != 0) {
                              await _dbhelper.editTaskDesc(_taskId, value);
                              setState(() {
                                _taskDescription = value;
                              });
                            }
                            _todoFocus.requestFocus();
                          }
                        },
                        focusNode: _descriptionFocus,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter task description...",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbhelper.getTodos(_taskId),
                        builder: (context, snapshot) => ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Todo todo = snapshot.data[index];
                            return GestureDetector(
                              onTap: () async {
                                await _dbhelper.editTodoState(
                                    todo.id, todo.isDone == 1 ? 0 : 1);
                                setState(() {});
                              },
                              child: TodoItem(
                                text: todo.title,
                                isDone: todo.isDone == 1,
                                deleteTodo: () async {
                                  await _dbhelper.deleteTodo(todo.id);
                                  setState(() {});
                                },
                                editTodo: () async {
                                  _todocontroller.text = todo.title;
                                  _todoFocus.requestFocus();
                                  await _dbhelper.deleteTodo(todo.id);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15.0),
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: Color(0XFF7349fe),
                                  width: 1.5,
                                )),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: _todocontroller,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskId != 0) {
                                    DatabaseHelper _dbhelper =
                                        new DatabaseHelper();
                                    await _dbhelper
                                        .insertTodo(
                                          new Todo(
                                            title: value,
                                            isDone: 0,
                                            taskId: _taskId,
                                          ),
                                        )
                                        .then((_) => setState(() {}));
                                    _todocontroller.clear();
                                    _todoFocus.requestFocus();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "I Guess Something Went Wrong"),
                                      ),
                                    );
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter todo item...",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 40,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _dbhelper.deleteTask(_taskId);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0XFFFE3577),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
