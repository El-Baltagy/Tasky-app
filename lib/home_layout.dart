import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sugar_to_do/screens/new_tasks/new_tasks_screen.dart';
import 'package:sugar_to_do/shared/components.dart';
import 'package:sugar_to_do/shared/cubit/cubit_file.dart';
import 'package:sugar_to_do/shared/cubit/states.dart';
import 'package:sugar_to_do/shared/network/notification.dart';
import 'package:sugar_to_do/shared/styles/colors.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init();
    listenNotification();
  }
void listenNotification()=>NotificationApi.onNotification;


  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: color1,
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 40),
              child: AppBar(
                elevation: 0,
                backgroundColor: color1,
                title: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Tasky App',
                  ),
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: FloatingActionButton(
                backgroundColor: color1.withOpacity(0.9),elevation: 100,
                onPressed: () {
                  if (cubit.isBottomSheetShown)
                  {
                    if (formKey.currentState!.validate())
                    {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );

                      NotificationApi.schdNotfication(
                          id:AppCubit.get(context).Tasks.length,
                          title: titleController.text,
                          msg: dateController.text,
                          payload: "Sugar To Do",

                          time: DateTime.parse("${dateController.text} ${timeController.text}"))
                          .catchError((e){
                            print(e.toString());
                      });
                    }
                  } else
                    {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => buildBottomSheet(context),
                          elevation: 20.0,)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });

                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            // bottomNavigationBar: SnakeNavigationBar.color(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   behaviour: SnakeBarBehaviour.floating,
            //      snakeShape: SnakeShape.rectangle,
            //     shape: Border.all(
            //       width: 4,
            //         style:BorderStyle.solid,
            //         // strokeAlign:2 ,
            //     color: color1
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 6),
            //   ///configuration for SnakeNavigationBar.color
            //   snakeViewColor: color1,
            //   selectedItemColor: color2w,
            //   // == SnakeShape.indicator ? selectedColor : null,
            //   unselectedItemColor: color1,
            //
            //   ///configuration for SnakeNavigationBar.gradient
            //   // snakeViewGradient: ,
            //   //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
            //   //unselectedItemGradient: unselectedGradient,
            //   // showUnselectedLabels: true,
            //   showSelectedLabels: true,
            //   currentIndex: cubit.currentIndex,
            //   onTap: (index){
            //     cubit.changeIndex(index);},
            //   items:cubit.bottomNav,
            // ),
            body:Container(
                margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 40),
                color: Colors.white,
                child: NewTasksScreen()),
          );
        },
      ),
    );
  }

  Container buildBottomSheet(BuildContext context) {
    return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(
                            20.0,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: ( value) {
                                    if (value!.isEmpty) {
                                      return 'Task Title must not be empty';
                                    }else{return null;}},
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: ( value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }else{return null;}
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2028-05-03'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: ( value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }else{return null;}
                                    },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        );
  }
}

// bottomNavigationBar: BottomNavigationBar(
//   type: BottomNavigationBarType.fixed,
//   currentIndex: cubit.currentIndex,
//   onTap: (index) {
//     cubit.changeIndex(index);
//   },
//   items: cubit.bottomNav,
// ),