import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class TodoLayout extends StatelessWidget {



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
              items: [
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
            body:state is GetFromDatabaseLoadingState? Center(child: CircularProgressIndicator()) :cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet)
                {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(title: titleController.text,
                        time: timeController.text,
                        date: dateController.text).then((value) {
                        Navigator.pop(context);
                        cubit.changeFloatingButtonIcon(boolSheet: false);

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
                            SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: defaultTextFormField(
                                  validateText: 'Title must not be empty',
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  label: 'Task Title',
                                  prefixIcon: Icon(Icons.title)),
                            ),
                            SizedBox(height: 12.0),
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
                                  prefixIcon: Icon(Icons.watch_later)),
                            ),
                            SizedBox(height: 12.0),
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
                                  prefixIcon: Icon(Icons.date_range)),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),


                          ],
                        ),
                      ),
                    );
                  },
                    elevation: 20.0,
                  ).closed.then((value) {
                    // setState(() {
                    cubit.changeFloatingButtonIcon(boolSheet: false);
                    // });

                  });
                  // setState(() {
                  cubit.changeFloatingButtonIcon(boolSheet: true);
                  // });
                }
              },
              child:cubit.isBottomSheet? Icon(Icons.add):Icon(Icons.edit),
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async{
    return 'Hazem Habib';
  }




}

