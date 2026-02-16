import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/vendor_bloc.dart';
import 'package:farmers_market/src/models/vendor.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:farmers_market/src/widgets/sliver_scaffold.dart';
import 'package:farmers_market/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditVendor extends StatefulWidget {
  final String? vendorId;

  const EditVendor({super.key, this.vendorId});

  @override
  State<EditVendor> createState() => _EditVendorState();
}

class _EditVendorState extends State<EditVendor> {
  StreamSubscription? _savedSubscription;

  @override
  void initState() {
    super.initState();
    final vendorBloc = Provider.of<VendorBloc>(context, listen: false);
    _savedSubscription = vendorBloc.vendorSaved.listen((saved) {
      if (saved == true) {
        Fluttertoast.showToast(
          msg: 'Vendor Saved',
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
    final vendorBloc = Provider.of<VendorBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);

    return FutureBuilder<Vendor?>(
      future: vendorBloc.fetchVendor(authBloc.userId ?? ''),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.vendorId != null) {
          return Scaffold(
            body: Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            ),
          );
        }

        final existingVendor = snapshot.data;
        loadValues(vendorBloc, existingVendor, authBloc.userId ?? '');

        final body = pageBody(Platform.isIOS, vendorBloc, existingVendor);

        return Platform.isIOS
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: '', pageBody: body)
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: '', pageBody: body);
      },
    );
  }

  Widget pageBody(bool isIOS, VendorBloc vendorBloc, Vendor? existingVendor) {
    final pageLabel = (existingVendor != null) ? 'Edit Profile' : 'Add Profile';

    return ListView(
      children: <Widget>[
        Text(pageLabel,
            style: TextStyles.subtitle, textAlign: TextAlign.center),
        Padding(
          padding: BaseStyles.listPadding,
          child: Divider(color: AppColors.darkblue),
        ),
        StreamBuilder<String>(
          stream: vendorBloc.name,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Vendor Name',
              cupertinoIcon: FontAwesomeIcons.basketShopping,
              materialIcon: FontAwesomeIcons.basketShopping,
              isIOS: isIOS,
              errorText: snapshot.error?.toString(),
              initialText: existingVendor?.name,
              onChanged: vendorBloc.changeName,
            );
          },
        ),
        StreamBuilder<String>(
          stream: vendorBloc.description,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Description',
              cupertinoIcon: FontAwesomeIcons.basketShopping,
              materialIcon: FontAwesomeIcons.basketShopping,
              isIOS: isIOS,
              errorText: snapshot.error?.toString(),
              initialText: existingVendor?.description,
              onChanged: vendorBloc.changeDescription,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: vendorBloc.isUploading,
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
          stream: vendorBloc.imageUrl,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AppButton(
                buttonType: ButtonType.Straw,
                buttonText: 'Add Image',
                onPressed: vendorBloc.pickImage,
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
                  onPressed: vendorBloc.pickImage,
                )
              ],
            );
          },
        ),
        StreamBuilder<bool>(
          stream: vendorBloc.isValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Profile',
              onPressed: vendorBloc.saveVendor,
            );
          },
        ),
      ],
    );
  }

  void loadValues(VendorBloc vendorBloc, Vendor? vendor, String vendorId) {
    vendorBloc.changeVendorId(vendorId);

    if (vendor != null) {
      vendorBloc.changeVendor(vendor);
      vendorBloc.changeName(vendor.name);
      vendorBloc.changeDescription(vendor.description);
      vendorBloc.changeImageUrl(vendor.imageUrl);
    } else {
      vendorBloc.changeVendor(null);
      vendorBloc.changeName('');
      vendorBloc.changeDescription('');
      vendorBloc.changeImageUrl('');
    }
  }
}
