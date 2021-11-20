class TodoItem {
  String title;
  String descriptions;
  String date;
  String time;
  bool done;

  TodoItem({required this.title, required this.descriptions, required this.time, required this.date, required this.done});

  toJSONEncodeAble() {
    Map<String, dynamic> m = {};

    m['title'] = title;
    m['descriptions'] = descriptions;
    m['date'] = date;
    m['time'] = time;
    m['done'] = done;

    return m;
  }
}