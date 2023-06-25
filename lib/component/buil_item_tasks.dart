import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget BuildIItemTasks(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model['title']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${model['date']}', style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          },
              icon: Icon(Icons.check_box,color: Colors.green,)),
          SizedBox(
            width: 15,
          ),
          IconButton(onPressed: (){
            AppCubit.get(context).updateData(status: 'archived', id: model['id']);

          }, icon: Icon(Icons.archive, color: Colors.black45,)),

        ],
      ),
    ),
    onDismissed: (direction){
       AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}
