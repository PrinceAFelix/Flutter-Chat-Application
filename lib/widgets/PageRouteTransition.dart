import 'package:flutter/material.dart';

class SlideLeft extends PageRouteBuilder{

  final Widget screen;
  SlideLeft({
    required this.screen
  }) : super(
    transitionDuration: Duration(seconds: 2),
    pageBuilder: (context, animation, secondAnimation) => screen,
  );

  @override
  Widget buildTransition(BuildContext context, Animation<double> animation, Animation<double> secondAnimation, Widget screen)
    => SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: screen,
    );
}