// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final Function onPressed;

  const LinedButton({
    Key key,
    @required this.child,
    this.color,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: color,
            style: BorderStyle.solid,
            width: 1.0),
        boxShadow: [
        // BoxShadow(
        //   color: Colors.grey[500],
        //   offset: Offset(0.0, 1.5),
        //   blurRadius: 1.5,
        // ),
      ],
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}