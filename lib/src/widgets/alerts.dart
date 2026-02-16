import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppAlerts {
  static Future<void> showErrorDialog(
      bool isIOS, BuildContext context, String errorMessage) async {
    return isIOS
        ? showCupertinoDialog<void>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Error', style: TextStyles.subtitle),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.body)
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            },
          )
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Error', style: TextStyles.subtitle),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(errorMessage, style: TextStyles.body)
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Okay', style: TextStyles.body),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            },
          );
  }
}
