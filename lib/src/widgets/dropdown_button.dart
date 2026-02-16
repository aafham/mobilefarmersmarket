import 'dart:io';

import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDropdownButton extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const AppDropdownButton({
    super.key,
    required this.items,
    required this.hintText,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: BaseStyles.listPadding,
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
            border: Border.all(
              color: AppColors.straw,
              width: BaseStyles.borderWidth,
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 35.0, child: BaseStyles.iconPrefix(materialIcon)),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    child: Text(
                      value ?? hintText,
                      style: (value == null)
                          ? TextStyles.suggestion
                          : TextStyles.body,
                    ),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => _selectIOS(context),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: BaseStyles.listPadding,
      child: Container(
        height: ButtonStyles.buttonHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
          border:
              Border.all(color: AppColors.straw, width: BaseStyles.borderWidth),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(width: 35.0, child: BaseStyles.iconPrefix(materialIcon)),
            Expanded(
              child: Center(
                child: DropdownButton<String>(
                  items: buildMaterialItems(items),
                  value: value,
                  hint: Text(hintText, style: TextStyles.suggestion),
                  style: TextStyles.body,
                  underline: const SizedBox.shrink(),
                  iconEnabledColor: AppColors.straw,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildMaterialItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, textAlign: TextAlign.center),
            ))
        .toList();
  }

  List<Widget> buildCupertinoItems(List<String> items) {
    return items
        .map((item) => Text(
              item,
              textAlign: TextAlign.center,
              style: TextStyles.picker,
            ))
        .toList();
  }

  Widget _selectIOS(BuildContext context) {
    final initialIndex =
        (value != null) ? items.indexWhere((item) => item == value) : 0;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.white,
        height: 200.0,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
              initialItem: initialIndex < 0 ? 0 : initialIndex),
          itemExtent: 45.0,
          children: buildCupertinoItems(items),
          diameterRatio: 1.0,
          onSelectedItemChanged: (index) => onChanged?.call(items[index]),
        ),
      ),
    );
  }
}
