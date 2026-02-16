import 'package:farmers_market/src/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppSliverScaffold {
  static CupertinoPageScaffold cupertinoSliverScaffold({
    required String navTitle,
    required Widget pageBody,
  }) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            AppNavbar.cupertinoNavBar(title: navTitle, context: context)
          ];
        },
        body: pageBody,
      ),
    );
  }

  static Scaffold materialSliverScaffold({
    required String navTitle,
    required Widget pageBody,
  }) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            AppNavbar.materialNavBar(title: navTitle, pinned: false)
          ];
        },
        body: pageBody,
      ),
    );
  }
}
