import 'package:flutter/material.dart';
import 'package:roll_dice_app/dice_roller.dart';


class GradientContainer extends StatelessWidget {
  const GradientContainer(this.colors, {super.key});
  final List<Color> colors;

  final Alignment startAlignment = Alignment.topLeft;
  final Alignment endAlignment = Alignment.bottomRight;

  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: const DiceRoller(),
    ));
  }
}
