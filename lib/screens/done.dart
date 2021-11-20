import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todolist/class/todo_item.dart';
import 'package:todolist/class/todo_list.dart';
import 'package:todolist/widgets/task.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  late List<Widget> donetasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done '),
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
              donetasks = list.items.where((element) => element.done==true).map((item) {
                  return TaskCard(
                    title: item.title,
                    descriptions: item.descriptions,
                    date: item.date,
                    time: item.time,
                    done: item.done,
                  );
                }).toList();
              if(donetasks.isEmpty){
                return const Center(
                  child: Text('Bạn chưa hoàn thành task nào hết :('),
                );
              }
              else {
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: donetasks,
                );
              }
            },
          )
      ),
    );
  }
}