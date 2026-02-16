import 'dart:io';

import 'package:farmers_market/src/blocs/customer_bloc.dart';
import 'package:farmers_market/src/models/market.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/list_tile.dart';
import 'package:farmers_market/src/widgets/sliver_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    final customerBloc = Provider.of<CustomerBloc>(context);
    final body = pageBody(context, customerBloc);

    if (Platform.isIOS) {
      return AppSliverScaffold.cupertinoSliverScaffold(
        navTitle: 'Upcoming Markets',
        pageBody: Scaffold(body: body),
      );
    }

    return AppSliverScaffold.materialSliverScaffold(
      navTitle: 'Upcoming Markets',
      pageBody: body,
    );
  }

  Widget pageBody(BuildContext context, CustomerBloc customerBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -10.0, child: Image.asset('assets/images/beans.jpg')),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/vendor'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightblue,
                      borderRadius:
                          BorderRadius.circular(BaseStyles.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Vendor Page',
                          style: TextStyles.buttonTextLight),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: StreamBuilder<List<Market>>(
            stream: customerBloc.fetchUpcomingMarkets,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Platform.isIOS
                      ? const CupertinoActivityIndicator()
                      : const CircularProgressIndicator(),
                );
              }

              final markets = snapshot.data!;
              return ListView.builder(
                itemCount: markets.length,
                itemBuilder: (BuildContext context, int index) {
                  final market = markets[index];
                  final dateEnd =
                      DateTime.tryParse(market.dateEnd) ?? DateTime.now();
                  return AppListTile(
                    marketId: market.marketId,
                    month: DateFormat('M').format(dateEnd),
                    date: DateFormat('d').format(dateEnd),
                    title: market.title,
                    location:
                        '${market.location.name}, ${market.location.address}, ${market.location.city}, ${market.location.state}',
                    acceptingOrders: market.acceptingOrders,
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
