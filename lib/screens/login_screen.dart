import 'package:anr/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: SvgPicture.asset('assets/logo.svg', width: 104),
              ),
              ElevatedButton.icon(
                key: const Key('sign_in_with_google_button'),
                icon: SvgPicture.asset('assets/google.svg', width: 24),
                label: Text(AppLocalizations.of(context)!.signInWithGoogle),
                onPressed: () => authenticationService.signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
