## Demo
<img src="./assets/bottom.gif?raw=true" width="200px"> <img src="./assets/top.gif?raw=true" width="200px">

## Description

You can easily use a bottom or top navigation bar just with a minimal code.
To use the NavBar please follow the instruction given below.

## Installing

Run this command:

With Flutter:

```

$ flutter pub add itbee_nav_bar

```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```

dependencies:
  itbee_nav_bar: ^0.0.1

```

Alternatively, your editor might support or `flutter pub get`. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```
import 'package:itbee_nav_bar/itbee_nav_bar.dart';
```


# Bottom NavBar

Align the Stack bottomCenter to use bottom NavBar.

```
Stack(
  ...
  alignment: Alignment.bottomCenter,
  ...

  children:[
    Container(),
    NavBar(
      ...
      ...
      ...
    ),
  ]
),
```


# Top NavBar

Align the Stack topCenter and change navBarAlignment to top of NavBar to use top navigation bar

```
Stack(
  ...
  alignment: Alignment.topCenter,
  ...

  children:[
    Container(),
    NavBar(
      ...
      navBarAlignment: 'top', // Default is bottom
      ...
    ),
  ]
),
```

# All available options to manipulate the NavBar appearance
```
NavBar(
  active: 0,
  navBarAlignment = 'bottom',
  activeButtonColor = Theme.of(context).colorScheme.secondary,
  activeButtonIconColor = Colors.white,
  inactiveButtonIconColor = Colors.white.withOpacity(0.5),
  navBarColor = Theme.of(context).colorScheme.primary,
  navBarAlignment: 'bottom',
  navBarColor: const Color(0xFF02BB9F),
  onTap: (active, itemName) {

  },
  childrencs : const [
  Icons.thumb_up,
  ...
  // upto 6 works fine.
  ],
)
```




# Example
`example/lib/main.dart`
```
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import the nav bar
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

  // this variable is holding which tab is currently active. initial value is
  // zero (0). 0 means the first tab is active one.
  // you must declare a variable (example: int activeButton) and assign an initial
  // value. here the initial value is 0.
  int activeButton = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
appBar: AppBar(
  title: Text('Demo Bottom NavBar', textDirection: TextDirection.ltr,),
),
        // to use the nav bar you must use a Stack widget and align it to bottomCenter
        // the second child will be our NavBar. the first child could be any widget.
        // may be a container where your rest of the code will be.
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


            // this is our NavBar.
            // to use the NavBar you must provide the active value which is the initial
            // active button position.
            NavBar(
              // here the initial active button is first one. cause activeButton value is 0.
              active: activeButton,
              navBarAlignment: 'bottom',
              navBarColor: const Color(0xFF02BB9F),
              activeButtonColor: Colors.amber,
              // onTap callBack returns two things. firstOne is user click button position
              // and second one the iconData which one is clicked.
              onTap: (active, itemName) {
                // you must assign the clicked button position to the variable you declare
                // for active button
                // activeButton = active;

                // here we call setState to update the ui.
                setState(() {
                  activeButton = active;
                });
              },

              // here you will pass iconData value. not the Icon.
              // upto 6 works fine.
              children: const [
                Icons.thumb_up,
                Icons.link,
                Icons.share,
                Icons.notification_important,
                Icons.home,
              ],
            ),
          ],
        ),
      )
    );
  }
}
```
