import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../layouts/todo_app/cubit/cubit.dart';


Widget defaultTextFormField({
  required String validateText,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String label,
  required Icon prefixIcon,
  Widget? suffixIcon,
  bool isPassword = false,
  Function? onSubmit,
  Function? onTap,
  Function? onChange,
  bool readOnly = false,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(

        validator: (value) {
          if (value!.isEmpty) {
            return validateText;
          }
        },
        onTap: () {
          onTap!();
        },
        readOnly: readOnly,
        obscureText: isPassword,
        controller: controller,
        onFieldSubmitted: (value) {
          onSubmit!();
        },
        onChanged: (value) {
          onChange!();
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.white,

          labelText: label,
          border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );

Widget taskItem(Map task, context) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed:(direction){
      TodoCubit.get(context).deleteFromDatabase(id: task['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.0,
            child: Text('${task['time']}'),
          ),
          const SizedBox(
            width: 25.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${task['title']}",
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${task['date']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDatabase(message: 'Moved to Done',status: 'done', id: task['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          const SizedBox(
            width: 6.0,
          ),
          IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDatabase(message: 'Moved to Archived',status: 'archive', id: task['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.blue,
              )),
        ],
      ),
    ),
  );
}

Widget emptyScreen(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.menu,size: 100.0,color: Colors.grey,),
        Text('There Are No Tasks Yet, Please Add Some Tasks',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14.0),)
      ],
    ),
  );
}


Widget buildDivider(){
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Container(
      color: Colors.grey[300],
      height: 1.0,
      width: double.infinity,
    ),
  );
}

Future<bool?> defaultToast({
  required String message,
  required ToastStates state,
}){
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: chooseToastColor(state),
  );
}

enum ToastStates{SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;

}