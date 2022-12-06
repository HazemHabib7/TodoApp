import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layouts/todo_app/cubit/states.dart';
import '../../../modules/todo_app/archived/archived_screen.dart';
import '../../../modules/todo_app/done/done_screen.dart';
import '../../../modules/todo_app/tasks/tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;
  List<String> title =[
    'Tasks',
    'Done',
    'Archived',
  ];
  List<Widget> screen = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  bool isBottomSheet = false;



  void changeBottomNavBar(int index){
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeFloatingButtonIcon({
  required bool boolSheet
}){
    isBottomSheet = boolSheet;
    emit(ChangeFloatingButtonIconState());
  }

  Future createDatabase ()
  {
      return openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        ).then((value) {
          emit(CreateDatabaseSuccessState());
          print('Table created');
        }).catchError((onError){
          emit(CreateDatabaseErrorState());
          print('Error When Creating Table ${onError.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database opened');
      },
    ).then((value) {
        database = value;
      });
  }

  Future getDataFromDatabase(database) async
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      emit(GetFromDatabaseSuccessState());
      print('$newTasks');
      value.forEach((element) {
        if(element['status']=='new') newTasks.add(element);
        else if(element['status']=='done') doneTasks.add(element);
        else archivedTasks.add(element);

      });
    }).catchError((onError){
      emit(GetFromDatabaseErrorState());
      print('Error When Get Date ${onError.toString()}');
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")'
      ).then((value) {
        emit(InsertIntoDatabaseSuccessState());
        print('${value.toString()} Inserted successfully');
        getDataFromDatabase(database);
      }).catchError((onError){
        emit(InsertIntoDatabaseErrorState());
        print('Error When Inserting Into The Table ${onError.toString()}');
      });
    });
  }

  void updateDatabase({
  required String status,
    required int id,
}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
          emit(UpdateDatabaseSuccessState());
          print('${value.toString()} Updated successfully');
          getDataFromDatabase(database);
    }).catchError((onError){
      emit(UpdateDatabaseErrorState());
      print('Error When Updating Into The Table ${onError.toString()}');
    });
  }

  void deleteFromDatabase({
    required int id,
  }) {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', ['$id'],).then((value) {
      emit(DeleteFromDatabaseSuccessState());
      print('${value.toString()} Deleted successfully');
      getDataFromDatabase(database);
    }).catchError((onError){
      emit(DeleteFromDatabaseErrorState());
      print('Error When Deleting Into The Table ${onError.toString()}');
    });
  }


}

