import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buil_item_tasks.dart';

Widget taskBuilder ({required List<Map> tasks})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) =>
          BuildIItemTasks(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: 20,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length),
  fallback: (context) =>const  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No tasks yet, Please add some tasks. ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    ),
  ),
);