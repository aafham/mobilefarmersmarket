import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/product_bloc.dart';
import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productBloc = Provider.of<ProductBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      body: pageBody(productBloc, context, authBloc.userId),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.straw,
        child: Icon(Platform.isIOS ? CupertinoIcons.add : Icons.add),
        onPressed: () => Navigator.of(context).pushNamed('/editproduct'),
      ),
    );
  }

  Widget pageBody(
      ProductBloc productBloc, BuildContext context, String? vendorId) {
    if (vendorId == null || vendorId.isEmpty) {
      return Center(
        child: Text(
          'Vendor belum ditemukan.',
          style: TextStyle(color: AppColors.darkgray),
        ),
      );
    }

    return StreamBuilder<List<Product>>(
      stream: productBloc.productByVendorId(vendorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        }

        final products = snapshot.data!;
        if (products.isEmpty) {
          return Center(
            child: Text(
              'Belum ada produk. Tekan tombol + untuk tambah produk baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkgray, fontSize: 16.0),
            ),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              child: AppCard(
                availableUnits: product.availableUnits,
                price: product.unitPrice,
                productName: product.productName,
                unitType: product.unitType,
                imageUrl: product.imageUrl,
                note: product.note,
              ),
              onTap: () => Navigator.of(context)
                  .pushNamed('/editproduct/${product.productId}'),
            );
          },
        );
      },
    );
  }
}
