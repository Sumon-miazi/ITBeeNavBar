library itbee_nav_bar;

import 'package:flutter/material.dart';

typedef OnTap = void Function(int position, String itemName);

class NavBar extends StatefulWidget {
  final OnTap onTap;
  final List<IconData> children;
  late int active;
  late Color? activeButtonColor;
  late Color? activeButtonIconColor;
  late Color? inactiveButtonIconColor;
  late Color? navBarColor;
  late String navBarAlignment;
  late double curveWidth;
  late double curveHeight;
  late double navBarHeight;
  final double activeButtonSize = 50;
  late double width;
  late double height;

  NavBar({
    Key? key,
    required this.onTap,
    required this.children,
    this.active = 0,
    this.navBarAlignment = 'bottom',
    this.activeButtonColor = const Color(0xFFFF9800),
    this.activeButtonIconColor,
    this.inactiveButtonIconColor,
    this.navBarColor,
    this.curveWidth = 100.0,
    this.curveHeight = 45.0,
    this.navBarHeight = 50.0,
  }) : super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacity;
  late double buttonOldPosition = 0.0;
  late double buttonNewPosition = 0.0;
  late double curveOldPosition = 0.0;
  late double curveNewPosition = 0.0;
  late double v = 0.0;

  late Animation navPosition =
      Tween(begin: buttonOldPosition, end: buttonNewPosition)
          .animate(_controller);
  late Animation curvePosition =
      Tween(begin: curveOldPosition, end: curveNewPosition)
          .animate(_controller);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _opacity = Tween(begin: 1.0, end: 0.0).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkColorValue(context);
    widget.width = MediaQuery.of(context).size.width;
    widget.height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: navBarPadding(),
          child:  ClipPath(
            clipper: BottomCurveClipper(
              navBarWidth: widget.width,
              navBarHeight: widget.navBarHeight,
              curvePos: curvePosition.value == 0.0
                  ? initialCurvePosition(context)
                  : curvePosition.value,
              curveWidth: widget.curveWidth,
              curveHeight: widget.curveHeight,
              navBarAlignment: widget.navBarAlignment,
            ),
            child: Container(
              color: widget.navBarColor,
              width: widget.width,
              height:widget.navBarHeight,
              //   alignment: Alignment.center,
              child: navigationItems(),
            ),
          ),
        ),

        Positioned(
          left: fabLeftPosition(context),
          bottom: fabBottomPosition(),

          child: FloatingActionButton(
            backgroundColor: widget.activeButtonColor,
            onPressed: () {
              print(widget.children[widget.active]);
            },
            child: ScaleTransition(
              scale: _animation,
              alignment: Alignment.center,
              child: Icon(
                widget.children[widget.active],
                color: widget.activeButtonIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double fabLeftPosition(BuildContext context) {
    return navPosition.value == 0.0
        ? initialButtonPosition(context)
        : navPosition.value;
  }

  double fabBottomPosition() {
    return widget.navBarHeight - widget.activeButtonSize * 0.85;
  }

  double initialCurvePosition(BuildContext context) {
    curveNewPosition = calculateActiveButtonPosition(context);
    return curveNewPosition;
  }

  double initialButtonPosition(BuildContext context) {
    buttonNewPosition = calculateActiveButtonPosition(context) +
        (widget.curveWidth / 4) -
        widget.activeButtonSize * 0.05;
    return buttonNewPosition;
  }

  double calculateActiveButtonPosition(BuildContext context) {
    double eachIconWidth = widget.width / (widget.children.length + 1.0);
    return (eachIconWidth * (1.0 + widget.active)) - (widget.curveWidth * 0.5);
  }

  Widget navigationItems() {
    List<Widget> items = [];
    items.add(Expanded(child: Container()));
    for (int i = 0; i < widget.children.length; i++) {
      items.add(GestureDetector(
          onTap: () {
            animation(i);
          },
          child: Opacity(
            opacity: i == widget.active ? _opacity.value : 1,
            child: Icon(
              widget.children[i],
              color: widget.inactiveButtonIconColor,
            ),
          )));

      items.add(Expanded(child: Container()));
    }
    return Row(children: items);
  }

  void animation(int position) {
    widget.active = position;
    print(widget.active);
    buttonOldPosition = buttonNewPosition;
    buttonNewPosition = calculateActiveButtonPosition(context) + (widget.curveWidth / 4) -
        widget.activeButtonSize * 0.05;
    curveOldPosition = curveNewPosition;
    curveNewPosition = calculateActiveButtonPosition(context);

    navPosition = Tween(begin: buttonOldPosition, end: buttonNewPosition)
        .animate(_controller);
    curvePosition = Tween(begin: curveOldPosition, end: curveNewPosition)
        .animate(_controller);

    _controller.reset();
    _controller.forward();

    widget.onTap(position, '${widget.children[position]}');

  }

  void checkColorValue(BuildContext context) {
    widget.activeButtonColor ??= Theme.of(context).colorScheme.secondary;
    widget.activeButtonIconColor ??= Colors.white;
    widget.inactiveButtonIconColor ??= Colors.white.withOpacity(0.5);
    widget.navBarColor ??= Theme.of(context).colorScheme.primary;
  }

  EdgeInsets navBarPadding() {
    if (widget.navBarAlignment == 'bottom') {
      return const EdgeInsets.only(top: 20);
    } else {
      return const EdgeInsets.only(bottom: 20);
    }
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  late double navBarWidth;
  late double navBarHeight;
  late double curvePos;
  late double curveWidth;
  late double curveHeight;
  late String navBarAlignment;
  late Offset topLeft;
  late Offset topRight;
  late Offset bottomLeft;
  late Offset bottomRight;


  BottomCurveClipper({
    required this.navBarWidth,
    required this.navBarHeight,
    required this.curvePos,
    required this.curveWidth,
    required this.curveHeight,
    required this.navBarAlignment,
  }) {

    if (navBarAlignment == 'bottom') {
      topLeft = const Offset(0, 0);
      topRight = Offset(navBarWidth, 0);
      bottomLeft = Offset(0, navBarHeight);
      bottomRight = Offset(navBarWidth, navBarHeight);
    } else {
      bottomLeft = const Offset(0, 0);
      bottomRight = Offset(navBarWidth, 0);
      topLeft = Offset(0, navBarHeight);
      topRight = Offset(navBarWidth, navBarHeight);
    }
  }

  @override
  Path getClip(Size size) {
    final path = Path();

    if (navBarAlignment == 'bottom') {
      path.lineTo(topLeft.dx, topLeft.dy);
      path.lineTo(curvePos, topLeft.dy);

      path.quadraticBezierTo(curveWidth * 0.15 + curvePos, 0,
          curveWidth * 0.2 + curvePos, curveHeight * 0.5);

      path.quadraticBezierTo(curveWidth * 0.3 + curvePos, curveHeight,
          curveWidth * 0.5 + curvePos, curveHeight);

      path.quadraticBezierTo(curveWidth * 0.7 + curvePos, curveHeight,
          curveWidth * 0.8 + curvePos, curveHeight * 0.5);

      path.quadraticBezierTo(
          curveWidth * 0.85 + curvePos, 0,
          curveWidth + curvePos, 0);

      path.lineTo(topRight.dx, topRight.dy);
      path.lineTo(bottomRight.dx, bottomRight.dy);
      path.lineTo(bottomLeft.dx, bottomLeft.dy);
    }
    else {
      path.lineTo(topLeft.dx, topLeft.dy);
      path.lineTo(curvePos, topLeft.dy);

      path.quadraticBezierTo(curveWidth * 0.15 + curvePos, navBarHeight,
          curveWidth * 0.2 + curvePos, navBarHeight - curveHeight * 0.5);

      path.quadraticBezierTo(
          curveWidth * 0.3 + curvePos,
          navBarHeight - curveHeight,
          curveWidth * 0.5 + curvePos,
          navBarHeight - curveHeight);

      path.quadraticBezierTo(
          curveWidth * 0.7 + curvePos,
          navBarHeight - curveHeight,
          curveWidth * 0.8 + curvePos,
          navBarHeight - curveHeight * 0.5);

      path.quadraticBezierTo(curveWidth * 0.85 + curvePos, navBarHeight,
          curveWidth + curvePos, navBarHeight);

      path.lineTo(topRight.dx, topRight.dy);
      path.lineTo(bottomRight.dx, bottomRight.dy);
      path.lineTo(bottomLeft.dx, bottomLeft.dy);
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
