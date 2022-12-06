import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layouts/todo_app/todo_layout.dart';
import 'package:todo_app/shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  BlocOverrides.runZoned(
        () async{
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoLayout()
    );
  }
}
