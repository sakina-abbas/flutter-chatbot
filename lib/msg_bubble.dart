import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  MessageBubble(this.message, this.isUser);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Bubble(
              radius: Radius.circular(10),
              nip: isUser ? BubbleNip.rightTop : BubbleNip.leftTop,
              color: isUser
                  ? Colors.orangeAccent
                  : Color.fromRGBO(23, 157, 139, 1),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
