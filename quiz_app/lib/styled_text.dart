import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text,  {super.key, this.color = Colors.white, this.fontsize = 18, this.textalign = TextAlign.start});

  final String text;
  final Color color;
  final double fontsize;
  final TextAlign textalign;


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontsize,
      ),
      textAlign: textalign,
    );
  }
}