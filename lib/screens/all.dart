import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todolist/class/todo_item.dart';
import 'package:todolist/class/todo_list.dart';
import 'package:todolist/widgets/task.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  _AllScreenState createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  late List<Widget> tasks;
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm',
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 18),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Clear',
          onPressed: () {
            if (_searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
        tooltip: 'Search',
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      tasks = list.items.where((element) => element.title.toLowerCase().contains(searchQuery.toLowerCase())).map((item) {
        return TaskCard(
          title: item.title,
          descriptions: item.descriptions,
          date: item.date,
          time: item.time,
          done: item.done,
        );
      }).toList();
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('All'),
        actions: _buildActions(),
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
              if(_isSearching==false) {
                  tasks = list.items.map((item) {
                  return TaskCard(
                    title: item.title,
                    descriptions: item.descriptions,
                    date: item.date,
                    time: item.time,
                    done: item.done,
                  );
                }).toList();
              }
              if(tasks.isEmpty){
                return const Center(
                  child: Text('Bạn chưa có task nào cả '),
                );
              }
              else{
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: tasks,
                );
              }

            },
          )
      ),
    );
  }
}
