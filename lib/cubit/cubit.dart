import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../screens/Archived_tasks/archived_tasks.dart';
import '../screens/done_tasks/done_tasks.dart';
import '../screens/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit () : super(AppInitialState());

 static AppCubit get (context)=> BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles =  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

 void changeBottomNavBarState(int index){
  currentIndex = index;
  emit(AppChangeBottomNavBarState());
}

  late Database database;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archidedTasks =[];

 void  createDatabase()  {
      openDatabase(
          'todoApp2.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,  time TEXT, date TEXT, status TEXT)')
              .then((value) {
            print('table created ');
          }).catchError((error) {
            print('error when created database${error.toString()}');
          });
        }, onOpen: (database) {
           getDataFromDatabase(database);
           print('database opened');
        }).then((value) {
        database = value;
        emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks (title, time, date, status) VALUES ("$title", "$time","$date","new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value) {


          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('error when inserting  database${error.toString()}');
      });
    });
  }

  void updateData({required String status, required int id}){
    newTasks =[];
    doneTasks =[];
    archidedTasks =[];
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id ]).then((value) {
      getDataFromDatabase(database);
     emit(AppUpdateDatabaseState());
    });
  }
  void deleteData({ required int id}){
    newTasks =[];
    doneTasks =[];
    archidedTasks =[];
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

   getDataFromDatabase(database)  {
   emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
        if(element['status'] == 'new') {newTasks.add(element);}
        else if(element['status'] == 'done') {doneTasks.add(element);}
        else if(element['status'] == 'archived') {archidedTasks.add(element);}
       });
       emit(AppGetDatabaseState());
     });
  }

  bool isShowBottomSheet = false;
  IconData flabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}){

    isShowBottomSheet = isShow;
    flabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
