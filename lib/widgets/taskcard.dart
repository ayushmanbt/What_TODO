import 'package:flutter/material.dart';

class Taskcard extends StatelessWidget {
  final String title;
  final String description;

  Taskcard({
    this.title: "~~Unnamed Task~~",
    this.description: "No Description added",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Color(0XFF211551),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            description,
            style: TextStyle(
              color: Color(0XFF86829D),
              fontSize: 16.0,
              height: 1.5,
            ),
          )
        ],
      ),
    );
  }
}
