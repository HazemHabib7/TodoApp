import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class TodoLayout extends StatelessWidget {

  TodoLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit,TodoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottomNavBar(index);
              },
            ),
            body:state is GetFromDatabaseLoadingState? const Center(child: CircularProgressIndicator()) :cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet)
                {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(title: titleController.text,
                        time: timeController.text,
                        date: dateController.text).then((value) {
                        Navigator.pop(context);
                        defaultToast(message: 'Inserted Successfully', state: ToastStates.SUCCESS);
                        cubit.changeFloatingButtonIcon(boolSheet: false);
                    }).catchError((onError){
                      defaultToast(message: onError.toString(), state: ToastStates.ERROR);
                    });
                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Container(
                      color: Colors.white,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: defaultTextFormField(
                                  validateText: 'Title must not be empty',
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  label: 'Task Title',
                                  prefixIcon: const Icon(Icons.title)),
                            ),
                            const SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: defaultTextFormField(
                                  validateText: 'Time must not be empty',
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: (){
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()).then((value) {
                                      timeController.text = value!.format(context).toString();
                                    });
                                  },
                                  label: 'Task Time',
                                  prefixIcon: const Icon(Icons.watch_later)),
                            ),
                            const SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: defaultTextFormField(
                                  validateText: 'Date must not be empty',
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.utc(2024)).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  label: 'Task Date',
                                  prefixIcon: const Icon(Icons.date_range)),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),


                          ],
                        ),
                      ),
                    );
                  },
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeFloatingButtonIcon(boolSheet: false);
                  });
                  cubit.changeFloatingButtonIcon(boolSheet: true);
                }
              },
              child:cubit.isBottomSheet? const Icon(Icons.add):const Icon(Icons.edit),
            ),
          );
        },
      ),
    );
  }

}

