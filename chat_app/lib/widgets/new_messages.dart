import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;

    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear(); // It will clear the inputField
    FocusScope.of(context)
        .unfocus(); // Focus will be lost disabling the soft keyboard

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('chat').add({
      "userId": user.uid,
      "createdAt": Timestamp.now(),
      "text": text,
      "username": userData.data()!['username'],
      "email": userData.data()!['email'],
      "image": userData.data()!['image_url']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 1, left: 13, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: "Enter your message...",
                labelStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
