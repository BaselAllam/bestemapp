import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';


class StatusWdiget extends StatefulWidget {
  final Color color;
  final String txt;
  const StatusWdiget({required this.color, required this.txt});

  @override
  State<StatusWdiget> createState() => _StatusWdigetState();
}

class _StatusWdigetState extends State<StatusWdiget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Text(widget.txt, style: AppFonts.subFontWhiteColor)
    );
  }
}