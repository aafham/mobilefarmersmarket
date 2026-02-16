import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCard extends StatelessWidget {
  final String productName;
  final String unitType;
  final int availableUnits;
  final double price;
  final String note;
  final String imageUrl;

  AppCard({
    super.key,
    required this.productName,
    required this.unitType,
    required this.availableUnits,
    required this.price,
    this.imageUrl = '',
    this.note = '',
  });

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;
    final hasNote = note.trim().isNotEmpty;
    final inStock = availableUnits > 0;

    return Container(
      margin: BaseStyles.listPadding,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        boxShadow: BaseStyles.boxShadow,
        color: Colors.white,
        border: Border.all(color: AppColors.lightgray, width: 1.2),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: hasImage
                    ? Image.network(
                        imageUrl,
                        height: 92.0,
                        width: 92.0,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/vegetables.png',
                          height: 92.0,
                          width: 92.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/vegetables.png',
                        height: 92.0,
                        width: 92.0,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(productName, style: TextStyles.listTitle),
                    const SizedBox(height: 4.0),
                    Text(
                      '${formatCurrency.format(price)}/$unitType',
                      style: TextStyles.body,
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: (inStock ? AppColors.green : AppColors.red)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        inStock ? 'In Stock' : 'Currently Unavailable',
                        style: inStock
                            ? TextStyles.bodyLightBlue
                            : TextStyles.bodyRed,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          hasNote
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(note.trim(), style: TextStyles.body),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
