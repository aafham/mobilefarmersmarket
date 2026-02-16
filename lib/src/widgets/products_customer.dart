import 'dart:io';

import 'package:farmers_market/src/blocs/customer_bloc.dart';
import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductsCustomer extends StatelessWidget {
  ProductsCustomer({super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final customerBloc = Provider.of<CustomerBloc>(context);

    return StreamBuilder<List<Product>>(
      stream: customerBloc.fetchAvailableProducts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        }

        final products = snapshot.data!;
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Column(
                      children: [
                        ListTile(
                          leading: ClipOval(
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/vegetables.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/vegetables.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          title: Text(
                            product.productName,
                            style: TextStyles.listTitle,
                          ),
                          subtitle: const Text('The Vendor'),
                          trailing: Text(
                            '${formatCurrency.format(product.unitPrice)}/${product.unitType}',
                            style: TextStyles.bodyLightBlue,
                          ),
                        ),
                        Divider(color: AppColors.lightgray),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 50.0,
                width: double.infinity,
                color: AppColors.straw,
                child: Icon(
                  Platform.isIOS
                      ? CupertinoIcons.slider_horizontal_3
                      : Icons.filter_list,
                  color: Colors.white,
                  size: 35.0,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
