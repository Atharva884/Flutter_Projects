import 'package:flutter/material.dart';
import 'package:quiz_app/styled_text.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, required this.text, required this.onTap});
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 45, 9, 130),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: StyledText(
        text,
        textalign: TextAlign.center,
      ),
    );
  }
}
