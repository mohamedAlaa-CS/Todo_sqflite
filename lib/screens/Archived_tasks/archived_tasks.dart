import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/component/task_builder.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context ,state){},
      builder: (context, state){
        var tasks = AppCubit.get(context).archidedTasks;
        return taskBuilder(tasks: tasks);},

    );
  }
}
