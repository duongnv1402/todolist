import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todolist/class/todo_item.dart';
import 'package:todolist/class/todo_list.dart';
import 'package:todolist/widgets/task.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({Key? key}) : super(key: key);
  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  late List<Widget> upcomingTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming '),
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!initialized) {
                var items = storage.getItem('todos');

                if (items != null) {
                  list.items = List<TodoItem>.from(
                    (items as List).map(
                          (item) => TodoItem(
                        title: item['title'],
                        descriptions: item['descriptions'],
                        done: item['done'],
                        time: item['time'],
                        date: item['date'],
                      ),
                    ),
                  );
                }
                initialized = true;
              }
              upcomingTask = list.items.where((element) => 0 < calculateDifference(DateTime.parse(element.date))).map((item) {
                return TaskCard(
                  title: item.title,
                  descriptions: item.descriptions,
                  date: item.date,
                  time: item.time,
                  done: item.done,
                );
              }).toList();
              if(upcomingTask.isEmpty){
                return const Center(
                  child: Text('Hãy tạo task mới cho mình bạn nhé'),
                );
              }
              else {
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: upcomingTask,
                );
              }
            },
          )
      ),
    );
  }
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}