import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String text;
  final bool isDone;

  final Function deleteTodo;
  final Function editTodo;

  TodoItem(
      {this.text: "Some unknown task",
      this.isDone: false,
      this.deleteTodo,
      this.editTodo});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 15.0),
              width: 30.0,
              height: 30.0,
              decoration: isDone
                  ? BoxDecoration(
                      color: Color(0XFF7349fe),
                      borderRadius: BorderRadius.circular(6.0),
                    )
                  : BoxDecoration(
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
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: !isDone ? Color(0XFF211551) : Color(0XFF86829D),
                  fontWeight: !isDone ? FontWeight.bold : FontWeight.w500,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (!isDone)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue[300],
                ),
                onPressed: editTodo,
              ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: deleteTodo,
            ),
          ],
        ),
      ),
    );
  }
}
