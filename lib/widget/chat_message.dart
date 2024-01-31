import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('sentAt', descending: false)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Your messages are loading"),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("Start your conversation"),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text("Something went wrong :("),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              return Text(loadedMessages[index].data()['text']);
            });
      },
    ));
  }
}
