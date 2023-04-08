import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:sugar_to_do/shared/styles/colors.dart';
import 'cubit/cubit_file.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String) ? onSubmit,
  Function(String) ? onChange,
  Function() ? onTap,
  bool isPassword = false,
String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) => TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: const OutlineInputBorder(),
      ),
    );


class buildTaskItem extends StatefulWidget {
  buildTaskItem(this.model);
final Map model;


  @override
  State<buildTaskItem> createState() => _buildTaskItemState();
}

class _buildTaskItemState extends State<buildTaskItem> {
  bool isChecked=false;
  int iconNumb=0;

  @override
  Widget build(BuildContext context) {

    return  Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed:  (context){
              setState(() {
                isChecked=false;
                iconNumb=1;
              });
              },
            icon: Icons.check_box,
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context){
             setState(() {
               isChecked=true;
               iconNumb=2;
             });
            },
            icon: Icons.archive,
            backgroundColor: Colors.black45,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context){
              AppCubit.get(context).deleteData(
                id: widget.model['id'],
              );
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child:   Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,backgroundColor: color1,
              child: Text(
                '${widget.model['time']}',
                style: TextStyle(
                  color: !isChecked?Colors.green:Colors.grey
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                '${widget.model['title']}',
                style:  TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: !isChecked?Colors.green:Colors.grey,
                  decoration:isChecked? TextDecoration.lineThrough:null,
                ),maxLines: 4,overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(
              width: 10.0,
            ),
           if(iconNumb==0)  SizedBox(
               height: 60,width: 100,
               child: Lottie.network('https://assets5.lottiefiles.com/packages/lf20_zmKJtL.json')),
           if(iconNumb==1) const Icon(Icons.check,color: Colors.green,),
           if(iconNumb==2) const Icon(Icons.archive,color: Colors.black45,),
          ],
        ),
      ),
    );
  }
}

Widget tasksBuilder({
  required isChecked,
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context,) => ListView.separated(
    itemBuilder: (context, index)
    {
      return buildTaskItem(tasks[index] );
    },
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
