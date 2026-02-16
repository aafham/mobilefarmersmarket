import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppNavbar {
  static CupertinoSliverNavigationBar cupertinoNavBar({
    required String title,
    required BuildContext context,
  }) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title, style: TextStyles.navTitle),
      backgroundColor: Colors.transparent,
      border: null,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Icon(CupertinoIcons.back, color: AppColors.straw),
      ),
    );
  }

  static SliverAppBar materialNavBar({
    required String title,
    bool pinned = true,
    TabBar? tabBar,
  }) {
    return SliverAppBar(
      title: Text(title, style: TextStyles.navTitleMaterial),
      backgroundColor: AppColors.darkblue,
      bottom: tabBar,
      floating: true,
      pinned: pinned,
      snap: true,
    );
  }
}
