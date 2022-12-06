import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layouts/todo_app/cubit/cubit.dart';
import 'package:todo_app/layouts/todo_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TodoCubit cubit = TodoCubit.get(context);
        return cubit.newTasks.isEmpty ? emptyScreen()
            :ListView.separated(
            itemBuilder: (context, index) => taskItem(cubit.newTasks[index],context),
            separatorBuilder: (context, index) => buildDivider(),
            itemCount: cubit.newTasks.length);
      },
    );
  }
}

