import 'package:flutter/material.dart';
class TaskCard extends StatefulWidget {
  final String title;
  final String descriptions;
  final String date;
  final String time;
  final bool done;
  final VoidCallback? onClick;
  const TaskCard({Key? key, required this.title, required this.descriptions, required this.date, required this.time, required this.done, this.onClick}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  IconData getIcon(bool done){
    return done ? Icons.radio_button_checked : Icons.radio_button_unchecked;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: IconButton(onPressed: widget.onClick,
                icon: Icon(getIcon(widget.done))),
            title: Text(widget.title),
            subtitle: Text(widget.descriptions),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(widget.time+' '),
              Text("${DateTime.parse(widget.date).toLocal()}".split(' ')[0]),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
