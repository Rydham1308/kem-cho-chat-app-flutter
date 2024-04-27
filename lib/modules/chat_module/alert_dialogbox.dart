import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback continueCallBack;

  const BlurryDialog(this.title, this.content, this.continueCallBack, {super.key});

  @override
  State<BlurryDialog> createState() => _BlurryDialogState();
}

class _BlurryDialogState extends State<BlurryDialog> {
  TextStyle textStyle = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            widget.title,
            style: textStyle,
          ),
          content: Text(
            widget.content,
            style: textStyle,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                widget.continueCallBack();
              },
            ),
          ],
        ));
  }
}
