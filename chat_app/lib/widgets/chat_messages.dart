import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Messages Found"),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong. Try Again later!"),
          );
        }

        final loadedMess = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
          reverse: true,
          itemCount: loadedMess.length,
          itemBuilder: (ctx, index) {
            // Here, we get currentChatMessage Map with the message and all meta data related to message such as username, userId, email
            final chatMessage = loadedMess[index].data();

            // Then we will find if(nextChatMessage is from same user)
            // It will evaluates to true if nextMessage exist from the same user
            // It will evaluates to false if nextMessage is from another user
            final nextChatMessage = index + 1 < loadedMess.length
                ? loadedMess[index + 1].data()
                : null;

            // Then, get the current id as username would be same
            final currentChatUserId = chatMessage['userId'];

            // Then, get the next id as username would be same
            final nextChatUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;

            // Then, we need to check if the currentUserId == nextChatUserId
            // If same, then the next message is from the same user
            final nextSameUser = currentChatUserId == nextChatUserId;

            if (nextSameUser) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: currentChatUserId == authenticatedUser.uid,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['image'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: currentChatUserId == authenticatedUser.uid,
              );
            }
          },
        );
      },
    );
  }
}
