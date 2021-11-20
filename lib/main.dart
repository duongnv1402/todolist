import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todolist/screens/add_a_task.dart';
import 'package:todolist/widgets/navigation_drawer.dart';
import 'package:todolist/widgets/task.dart';
import 'class/todo_item.dart';
import 'class/todo_list.dart';

void main() {
  runApp(const MaterialApp(
    title: 'To do app',
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      child: MyMainScreen(),
    ),
  ));
}

class MyMainScreen extends StatefulWidget {
  const MyMainScreen({Key? key}) : super(key: key);

  @override
  _MyMainScreenState createState() => _MyMainScreenState();
}

class _MyMainScreenState extends State<MyMainScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;

  _toggleItem(TodoItem item) {
    final snackBar = SnackBar(content: Text('Bạn đã hoàn thành '+item.title));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddATask(),
        ));
    if(result!=null){
      final snackBar = SnackBar(content: Text('Bạn đã thêm '+result.title));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        list.items.add(result);
        _saveToStorage();
      });
    }
  }
  _clearStorage() async {
    await storage.clear();
    setState(() {
      list.items = storage.getItem('todos') ?? [];
    });
  }
  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodeAble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
        IconButton(
           icon: const Icon(Icons.delete),
           onPressed: _clearStorage,
           tooltip: 'Clear all task',
         ),
        ],
      ),
      drawer: const NavigationDrawer(),
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
              List<Widget> todayTasks = list.items.where((element) => !element.done)
                  .where((element) => 0 == calculateDifference(DateTime.parse(element.date)))
                  .map((item) {
                return TaskCard(
                  title: item.title,
                  descriptions: item.descriptions,
                  date: item.date,
                  time: item.time,
                  done: item.done,
                  onClick: ()=>_toggleItem(item),
                );
              }).toList();
              if(todayTasks.isEmpty) {
                return const Center(
                  child: Text('Bạn đã hoàn thành hết các task của hôm nay rồi '),
                );
              }
              else {
                return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: todayTasks,
              );
              }
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ()=>_awaitReturnValueFromSecondScreen(context),
        tooltip: 'Add a task',

      ),
      );
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}

