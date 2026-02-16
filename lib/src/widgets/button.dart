import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.buttonText,
    this.buttonType = ButtonType.LightBlue,
    this.onPressed,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  Color _buttonColor(ButtonType type) {
    switch (type) {
      case ButtonType.Straw:
        return AppColors.straw;
      case ButtonType.LightBlue:
        return AppColors.lightblue;
      case ButtonType.DarkBlue:
        return AppColors.darkblue;
      case ButtonType.Disabled:
        return AppColors.lightgray;
      case ButtonType.DarkGray:
        return AppColors.darkgray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _buttonColor(widget.buttonType);

    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: pressed
            ? BaseStyles.listFieldVertical + BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        bottom: pressed
            ? BaseStyles.listFieldVertical - BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal,
      ),
      duration: const Duration(milliseconds: 20),
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.buttonType != ButtonType.Disabled) {
            setState(() => pressed = true);
          }
        },
        onTapCancel: () {
          if (widget.buttonType != ButtonType.Disabled) {
            setState(() => pressed = false);
          }
        },
        onTapUp: (_) {
          if (widget.buttonType != ButtonType.Disabled) {
            setState(() => pressed = false);
          }
        },
        onTap: () {
          if (widget.buttonType != ButtonType.Disabled) {
            widget.onPressed?.call();
          }
        },
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
            boxShadow:
                pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow,
          ),
          child: Center(
            child: Text(widget.buttonText, style: TextStyles.buttonTextLight),
          ),
        ),
      ),
    );
  }
}

enum ButtonType { LightBlue, Straw, Disabled, DarkGray, DarkBlue }
