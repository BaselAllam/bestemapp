import 'package:flutter/material.dart';



class TxtBtn extends StatefulWidget {
  final String txt;
  Function onPress;
  final TextStyle textStyle;
  TxtBtn(this.txt, this.textStyle, this.onPress);

  @override
  State<TxtBtn> createState() => _TxtBtnState();
}

class _TxtBtnState extends State<TxtBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPress();
      },
      child: Text(widget.txt, style: widget.textStyle),
    );
  }
}