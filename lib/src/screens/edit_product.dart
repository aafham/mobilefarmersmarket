import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/product_bloc.dart';
import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:farmers_market/src/widgets/dropdown_button.dart';
import 'package:farmers_market/src/widgets/sliver_scaffold.dart';
import 'package:farmers_market/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final String? productId;

  const EditProduct({super.key, this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  StreamSubscription? _savedSubscription;

  @override
  void initState() {
    super.initState();
    final productBloc = Provider.of<ProductBloc>(context, listen: false);
    _savedSubscription = productBloc.productSaved.listen((saved) {
      if (saved == true) {
        Fluttertoast.showToast(
          msg: 'Product Saved',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColors.lightblue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _savedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = Provider.of<ProductBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);

    return FutureBuilder<Product?>(
      future: productBloc.fetchProduct(widget.productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.productId != null) {
          return Scaffold(
            body: Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            ),
          );
        }

        final existingProduct = snapshot.data;
        loadValues(productBloc, existingProduct, authBloc.userId ?? '');

        final body = pageBody(
          Platform.isIOS,
          productBloc,
          context,
          existingProduct,
        );

        return Platform.isIOS
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: '', pageBody: body)
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: '', pageBody: body);
      },
    );
  }

  Widget pageBody(
    bool isIOS,
    ProductBloc productBloc,
    BuildContext context,
    Product? existingProduct,
  ) {
    final items = Provider.of<List<String>>(context, listen: false);
    final pageLabel =
        (existingProduct != null) ? 'Edit Product' : 'Add Product';

    return ListView(
      children: <Widget>[
        Text(pageLabel,
            style: TextStyles.subtitle, textAlign: TextAlign.center),
        Padding(
          padding: BaseStyles.listPadding,
          child: Divider(color: AppColors.darkblue),
        ),
        StreamBuilder<String>(
          stream: productBloc.productName,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Product Name',
              cupertinoIcon: FontAwesomeIcons.basketShopping,
              materialIcon: FontAwesomeIcons.basketShopping,
              isIOS: isIOS,
              errorText: snapshot.error?.toString(),
              initialText: existingProduct?.productName,
              onChanged: productBloc.changeProductName,
            );
          },
        ),
        StreamBuilder<String?>(
          stream: productBloc.unitType,
          builder: (context, snapshot) {
            return AppDropdownButton(
              hintText: 'Unit Type',
              items: items,
              value: snapshot.data,
              materialIcon: FontAwesomeIcons.scaleBalanced,
              cupertinoIcon: FontAwesomeIcons.scaleBalanced,
              onChanged: productBloc.changeUnitType,
            );
          },
        ),
        StreamBuilder<double>(
          stream: productBloc.unitPrice,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Unit Price',
              cupertinoIcon: FontAwesomeIcons.tag,
              materialIcon: FontAwesomeIcons.tag,
              isIOS: isIOS,
              textInputType: TextInputType.number,
              errorText: snapshot.error?.toString(),
              initialText: existingProduct?.unitPrice.toString(),
              onChanged: productBloc.changeUnitPrice,
            );
          },
        ),
        StreamBuilder<int>(
          stream: productBloc.availableUnits,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Available Units',
              cupertinoIcon: FontAwesomeIcons.cubes,
              materialIcon: FontAwesomeIcons.cubes,
              isIOS: isIOS,
              textInputType: TextInputType.number,
              errorText: snapshot.error?.toString(),
              initialText: existingProduct?.availableUnits.toString(),
              onChanged: productBloc.changeAvailableUnits,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: productBloc.isUploading,
          builder: (context, snapshot) {
            return (snapshot.data == true)
                ? Center(
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
                  )
                : const SizedBox.shrink();
          },
        ),
        StreamBuilder<String>(
          stream: productBloc.imageUrl,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AppButton(
                buttonType: ButtonType.Straw,
                buttonText: 'Add Image',
                onPressed: productBloc.pickImage,
              );
            }

            return Column(
              children: <Widget>[
                Padding(
                  padding: BaseStyles.listPadding,
                  child: Image.network(snapshot.data!),
                ),
                AppButton(
                  buttonType: ButtonType.Straw,
                  buttonText: 'Change Image',
                  onPressed: productBloc.pickImage,
                )
              ],
            );
          },
        ),
        StreamBuilder<bool>(
          stream: productBloc.isValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Product',
              onPressed: productBloc.saveProduct,
            );
          },
        ),
      ],
    );
  }

  void loadValues(ProductBloc productBloc, Product? product, String vendorId) {
    productBloc.changeProduct(product);
    productBloc.changeVendorId(vendorId);

    if (product != null) {
      productBloc.changeUnitType(product.unitType);
      productBloc.changeProductName(product.productName);
      productBloc.changeUnitPrice(product.unitPrice.toString());
      productBloc.changeAvailableUnits(product.availableUnits.toString());
      productBloc.changeImageUrl(product.imageUrl);
    } else {
      productBloc.changeUnitType(null);
      productBloc.changeProductName('');
      productBloc.changeUnitPrice('');
      productBloc.changeAvailableUnits('');
      productBloc.changeImageUrl('');
    }
  }
}
