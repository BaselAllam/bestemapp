import 'package:flutter/material.dart';



class CustomBtn extends StatefulWidget {
  final Widget widget;
  final Size size;
  final Color color;
  final double radius;
  Function onPress;
  final BorderSide borderSide;
  double opacity;
  CustomBtn({required this.widget, required this.size, required this.color, required this.radius, this.borderSide = BorderSide.none, required this.onPress, this.opacity = 1.0});

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity,
      child: TextButton(
        child: widget.widget,
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          fixedSize: widget.size,
          backgroundColor: widget.color,
          side: widget.borderSide,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius))
        ),
        onPressed: () {
          widget.onPress();
        },
      ),
    );
  }
}