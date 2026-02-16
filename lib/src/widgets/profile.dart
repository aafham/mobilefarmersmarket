import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Platform.isIOS
          ? CupertinoButton(
              child: const Text('Add'),
              onPressed: () => Navigator.of(context).pushNamed('/editvendor'),
            )
          : TextButton(
              child: const Text('Add'),
              onPressed: () => Navigator.of(context).pushNamed('/editvendor'),
            ),
    );

    if (Platform.isIOS) {
      return CupertinoPageScaffold(child: body);
    }
    return Scaffold(body: body);
  }
}
