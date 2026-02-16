import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSocialButton extends StatelessWidget {
  final SocialType socialType;

  const AppSocialButton({super.key, required this.socialType});

  @override
  Widget build(BuildContext context) {
    final buttonColor = socialType == SocialType.Facebook
        ? AppColors.facebook
        : AppColors.google;
    final icon = socialType == SocialType.Facebook
        ? FontAwesomeIcons.facebookF
        : FontAwesomeIcons.google;

    return Container(
      height: ButtonStyles.buttonHeight,
      width: ButtonStyles.buttonHeight,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
        boxShadow: BaseStyles.boxShadow,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

enum SocialType { Facebook, Google }
