import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/customer_bloc.dart';
import 'package:farmers_market/src/blocs/product_bloc.dart';
import 'package:farmers_market/src/blocs/vendor_bloc.dart';
import 'package:farmers_market/src/routes.dart';
import 'package:farmers_market/src/screens/landing.dart';
import 'package:farmers_market/src/screens/login.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final authBloc = AuthBloc();
final productBloc = ProductBloc();
final customerBloc = CustomerBloc();
final vendorBloc = VendorBloc();
final firestoreService = FirestoreService();

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>(create: (context) => authBloc),
        Provider<ProductBloc>(create: (context) => productBloc),
        Provider<CustomerBloc>(create: (context) => customerBloc),
        Provider<VendorBloc>(create: (context) => vendorBloc),
        FutureProvider<bool?>(
          create: (context) => authBloc.isLoggedIn(),
          initialData: null,
        ),
        StreamProvider<List<String>>(
          create: (context) => firestoreService.fetchUnitTypes(),
          initialData: const <String>[],
        ),
      ],
      child: PlatformApp(),
    );
  }

  @override
  void dispose() {
    authBloc.dispose();
    productBloc.dispose();
    customerBloc.dispose();
    vendorBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<bool?>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        home: (isLoggedIn == null)
            ? loadingScreen(true)
            : (isLoggedIn ? Landing() : Login()),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(
          primaryColor: AppColors.straw,
          scaffoldBackgroundColor: Colors.white,
          textTheme:
              CupertinoTextThemeData(tabLabelTextStyle: TextStyles.suggestion),
        ),
      );
    } else {
      return MaterialApp(
        home: (isLoggedIn == null)
            ? loadingScreen(false)
            : (isLoggedIn ? Landing() : Login()),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      );
    }
  }

  Widget loadingScreen(bool isIOS) {
    return isIOS
        ? CupertinoPageScaffold(
            child: Center(child: CupertinoActivityIndicator()),
          )
        : Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
