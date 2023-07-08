import 'package:flutter/material.dart';
import 'package:roll_dice_app/styled_text.dart';
import 'dart:math';

var randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {

  int randomValue = 1;

  void rollDice(){
    setState(() {
      randomValue = randomizer.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/dice-$randomValue.png", width: 300,),
          const SizedBox(height: 20),
          TextButton(
              onPressed: rollDice,
              child: const StyledText(text: "Roll Dice")
          )
        ],
      );
  }
}