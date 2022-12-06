import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layouts/todo_app/cubit/cubit.dart';
import 'package:todo_app/layouts/todo_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TodoCubit cubit = TodoCubit.get(context);
        return cubit.archivedTasks.length==0 ? emptyScreen()
            : ListView.separated(
            itemBuilder: (context, index) => taskItem(cubit.archivedTasks[index],context),
            separatorBuilder: (context, index) => buildDivider(),
            itemCount: cubit.archivedTasks.length);
      },
    );
  }
}
