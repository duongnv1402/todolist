import 'package:flutter/material.dart';
import 'package:todolist/screens/all.dart';
import 'package:todolist/screens/done.dart';
import 'package:todolist/screens/upcoming.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.lightBlue,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 48),
            buildMenuItem(
              text: 'Today',
              icon: Icons.today,
              onClicked: ()=> selectedItem(context,1),
            ),
            buildMenuItem(
              text: 'All',
              icon: Icons.apps,
              onClicked: ()=> selectedItem(context,0),
            ),
            buildMenuItem(
              text: 'Upcoming',
              icon: Icons.calendar_today,
              onClicked: ()=> selectedItem(context,2),
            ),
            buildMenuItem(
              text: 'Done',
              icon: Icons.done,
              onClicked: ()=> selectedItem(context,3),
            ),
          ],
        ),
      ),
    );
  }
}
Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;
  return ListTile(
    leading: Icon(icon, color: color,),
    title: Text(text, style: TextStyle(color: color),),
    hoverColor: hoverColor,
    onTap: onClicked,
  );

}
void selectedItem(BuildContext context, int index){
  switch(index){
    case 0:
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const AllScreen(),
      ));
      break;
    case 1:
      Navigator.pop(context);
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const UpcomingScreen(),
      ));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const DoneScreen(),
      ));
      break;
  }
}