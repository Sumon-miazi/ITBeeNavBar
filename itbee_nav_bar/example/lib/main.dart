import 'package:flutter/cupertino.dart';
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bottom navigation', textDirection: TextDirection.ltr,),
        ),
        body: Stack(
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
              active: activeButton,
              onTap: (active, itemName) {
                setState(() {
                  activeButton = active;
                });
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
      )
    );
  }
}




