import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/const.dart';
import 'package:to_do/cubit/States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Archived_tasks.dart';
import '../Done_tasks.dart';
import '../new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  List<Widget> screens = [
    Newtasks(),
    Donetasks(),
    Archivedtasks(),
  ];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  void changeIndex(int index) {
    currentindex = index;
    emit(AppChangeBotttomNavBarStates());
  }

  Database datebase;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void createDatebass() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (datebase, version) {
        
        datebase
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print("datebase created");
          print("table created");
        }).catchError((error) {
          print("Error when creating table ${error.toString()}");
        });
      },
      onOpen: (datebase)
       {
        
        getDataFromDatebase(datebase);
      },
    ).then((value) {
      datebase = value;
      emit(AppCreateDatebaseStates());
    });
  }

   insertTodatebase(
   {
    @required String title,
    @required String time,
    @required String date,

   }
   

  ) async {
     await datebase.transaction((txn) async{
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',)
          .then((value) 
        {
          print(' $value inserted successfuly');
          emit(AppInsertDatebaseStates());
        getDataFromDatebase(datebase);
       
        }).catchError((error) {
          print('error when inserting new row:$error.toString()}');
        });
    });
  }

 void getDataFromDatebase(datebase)  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatebaseLoadingStates());
     datebase.rawQuery("SELECT*FROM tasks").then((value) {
      
         
          value.forEach((element) { 
if(element['status']=='new'){
  newTasks.add(element);
  }
  else if(element['status']=='done'){
  doneTasks.add(element);
  }
 else
  archivedTasks.add(element);

          });
          emit(AppGetDatebaseStates());
        });
  }
   bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit;
  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }){
isbottomsheetshown=isShow;
fabicon=icon;
emit(AppchangeBottomSheetStates());
  }
  void updateDate({
    @required String status,

    @required int id,
  }) async {
  await   datebase.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status', id ],
    ).then((value) {
      getDataFromDatebase(datebase);
      emit(AppUpdatetDatebaseStates());
    });
    
}



 void deleteDate({
    

    @required int id,
  }) async {
    await datebase.rawDelete(
    'DELETE FROM tasks  WHERE id = ?',[id]
   ).then((value) {
      getDataFromDatebase(datebase);
      emit(AppDeleteDatebaseStates());
    });
    
}

}