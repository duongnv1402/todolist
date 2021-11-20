import 'package:todolist/class/todo_item.dart';

class TodoList {
  List<TodoItem> items = [];

  toJSONEncodeAble() {
    return items.map((item) {
      return item.toJSONEncodeAble();
    }).toList();
  }
  delete(TodoItem item){
    if(items.contains(item)){
      items.remove(item);
    }
  }
}