import 'package:flutter/material.dart';
import 'package:todolist/class/todo_item.dart';

class AddATask extends StatefulWidget {
  const AddATask({Key? key}) : super(key: key);

  @override
  _AddATaskState createState() => _AddATaskState();
}

class _AddATaskState extends State<AddATask> {

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final taskController = TextEditingController();
  final descriptionsController = TextEditingController();
  late SnackBar snackBar;
  Future pickDate(BuildContext context) async{
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5 ),
      lastDate: DateTime(DateTime.now().year + 5 ),
    );
    if(newDate != null && newDate != selectedDate) {
      setState(() => selectedDate = newDate);
    }
  }

  Future pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (newTime != null && newTime != selectedTime) {
      setState(() => selectedTime = newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    TodoItem item;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: Column(
        children: [
          TextField(
            controller: taskController,
            decoration: const InputDecoration(
              labelText: 'Task',
            ),
          ),
          TextField(
            controller: descriptionsController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Descriptions',
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () => pickDate(context), icon: const Icon(Icons.date_range)),
              Text("${selectedDate.toLocal()}".split(' ')[0]),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: ()=> pickTime(context), icon: const Icon(Icons.access_time)),
              Text('${selectedTime.hour}: ${selectedTime.minute}'),
            ],
          ),
        ],
      ),
      ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.done),
          onPressed: ()=>{
            if(taskController.text.replaceAll(' ', '')!='')
              {
                item = TodoItem(
                    title: taskController.text,
                    descriptions: descriptionsController.text,
                    time: selectedTime.toString().split("(")[1].split(")")[0],
                    date: selectedDate.toString(), done: false
                ),
                Navigator.pop(context, item)
              }
            else {
            snackBar = const SnackBar(content:  Text('Hãy điền tiêu đề')),
            ScaffoldMessenger.of(context).showSnackBar(snackBar),
            }
    }
    ),
    );

  }
}
