
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';



class HomePage extends StatelessWidget {

  HomePage({Key? key}) : super(key: key);


    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();

    var titleController = TextEditingController();
    var timeController = TextEditingController();
    var dateController = TextEditingController();


    // @override
    // void initState() {
    //   super.initState();
    //   createDatabase();
    // }

    @override
    Widget build(BuildContext context) {

      return BlocProvider(

        create: (context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: ( BuildContext context,AppStates state){
              if(state is AppInsertDatabaseState){
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context,AppStates state){
              AppCubit cubit = AppCubit.get(context);

              return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: ConditionalBuilder (
                condition:state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>const  Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isShowBottomSheet) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);

                     }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'New Tasks',
                                  prefixIcon: Icon(
                                    Icons.title,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                             const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                    print(value?.format(context));
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Time Tasks',
                                  prefixIcon: Icon(
                                    Icons.watch_later_outlined,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                             const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2024-08-15'),
                                  ).then((value) {
                                    print(DateFormat.yMMMd().format(value!));
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Task Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                        .closed
                        .then((value) {
                          cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                          timeController.text='';
                          titleController.text='';
                          dateController.text='';

                    });
                        cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                  }
                },
                child: Icon(cubit.flabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                iconSize: 30,
                currentIndex: cubit.currentIndex,
                onTap: (index) {

                  cubit.changeBottomNavBarState(index);

                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
                ],
              ),
            );},
        ),
      );
    }
    //
    // Future<String> printName() async {
    //   return 'mohamed alaa';
    // }

      }




