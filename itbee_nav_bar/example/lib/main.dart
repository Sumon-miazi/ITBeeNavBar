import 'package:flutter/material.dart';
import 'package:itbee_nav_bar/itbee_nav_bar.dart';

void main() {
  runApp(const Demo());
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  int activeButton = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(child: Text('Active button is $activeButton',
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.orange,
              fontSize: 20,
            ),
          )),
          NavBar(
            onTap: (position, itemName) {
              changeValue(position);
            //  print('position $position and name $itemName');
            },
            children: const [
              Icons.thumb_up,
              Icons.link,
              Icons.share,
              Icons.notification_important,
              Icons.home,
              //     Icons.menu,
            ],
          ),
        ],
      ),
    );
  }

  void changeValue(int position) {
    setState(() {
      activeButton = position;
    });
  }
}


