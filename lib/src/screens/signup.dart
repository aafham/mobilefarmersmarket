import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/alerts.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:farmers_market/src/widgets/social_button.dart';
import 'package:farmers_market/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late StreamSubscription _userSubscription;
  late StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    super.initState();
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.user.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/landing');
      }
    });

    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage.isNotEmpty) {
        AppAlerts.showErrorDialog(Platform.isIOS, context, errorMessage)
            .then((_) => authBloc.clearErrorMessage());
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final body = pageBody(context, authBloc);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(child: body);
    }
    return Scaffold(body: body);
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .2,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/top_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(
          height: 200.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage('assets/images/logo.png')),
            ),
          ),
        ),
        StreamBuilder<String>(
          stream: authBloc.email,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Email',
              cupertinoIcon: CupertinoIcons.mail_solid,
              materialIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
              errorText: snapshot.error?.toString(),
              onChanged: authBloc.changeEmail,
            );
          },
        ),
        StreamBuilder<String>(
          stream: authBloc.password,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Password',
              cupertinoIcon: IconData(
                0xf4c9,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
              materialIcon: Icons.lock,
              obscureText: true,
              errorText: snapshot.error?.toString(),
              onChanged: authBloc.changePassword,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: authBloc.isValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonText: 'Signup',
              buttonType: (snapshot.data == true)
                  ? ButtonType.LightBlue
                  : ButtonType.Disabled,
              onPressed: authBloc.signupEmail,
            );
          },
        ),
        const SizedBox(height: 6.0),
        Center(child: Text('Or', style: TextStyles.suggestion)),
        const SizedBox(height: 6.0),
        Padding(
          padding: BaseStyles.listPadding,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppSocialButton(socialType: SocialType.Facebook),
              SizedBox(width: 15.0),
              AppSocialButton(socialType: SocialType.Google),
            ],
          ),
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Already Have an Account? ',
              style: TextStyles.body,
              children: [
                TextSpan(
                  text: 'Login',
                  style: TextStyles.link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushNamed(context, '/login'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
