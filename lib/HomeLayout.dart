import 'package:flutter/material.dart';


import 'package:to_do/cubit/States.dart';
import 'package:to_do/cubit/cubit.dart';


import 'package:intl/intl.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class Hoome extends StatelessWidget {
  
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formdkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebass(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatebaseStates) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentindex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatebaseLoadingStates,
              builder: (context) => cubit.screens[cubit.currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabicon),
              onPressed: () {
                if (cubit.isbottomsheetshown) {
                  if (formdkey.currentState.validate()) {
                    cubit.insertTodatebase( 
                      title:titlecontroller.text,
                      time:  timecontroller.text,
                      date: datecontroller.text);
                  }
                } else {
                  scaffoldkey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formdkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titlecontroller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.text_fields),
                                    labelText: "Task Title",
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: timecontroller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.watch),
                                    labelText: "Task time",
                                  ),
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timecontroller.text =
                                          value.format(context).toString();
                                    });
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: datecontroller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today),
                                    labelText: "Task Date",
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-12-15'),
                                    ).then((value) {
                                      datecontroller.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
