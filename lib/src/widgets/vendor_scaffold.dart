import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/widgets/orders.dart';
import 'package:farmers_market/src/widgets/products.dart';
import 'package:farmers_market/src/widgets/profile.dart';
import 'package:flutter/cupertino.dart';

abstract class VendorScaffold {
  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTabBar,
      tabBuilder: (context, index) => _pageSelection(index),
    );
  }

  static CupertinoTabBar get _cupertinoTabBar {
    return CupertinoTabBar(
      backgroundColor: AppColors.darkblue,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.create),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.shopping_cart),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  static Widget _pageSelection(int index) {
    if (index == 0) return Products();
    if (index == 1) return Orders();
    return const Profile();
  }
}
