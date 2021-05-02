import 'package:flutter/material.dart';
import 'package:what_todo/models/task.dart';
import '../database_helper.dart';
import 'taskpage.dart';
import '../widgets/taskcard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0XFFF6F6F6),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Image(
                      width: 50,
                      height: 64,
                      image: AssetImage(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.data.length == 0) {
                          return Center(
                              child: Text(
                            "No tasks added, consider adding a task?",
                            style: TextStyle(fontSize: 20),
                          ));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final Task task = snapshot.data[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => TaskPage(task: task),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              child: Taskcard(
                                title: task.title,
                                description: task.description != null
                                    ? task.description
                                    : "No description provided",
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskPage(
                        task: null,
                      ),
                    ),
                  ).then((value) => setState(() {})),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0XFF7349FE),
                          Color(0XFF643FDE),
                        ],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
