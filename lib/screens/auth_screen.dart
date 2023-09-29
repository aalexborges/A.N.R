import 'package:anr/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                child: SvgPicture.asset('assets/images/logo.svg', width: 104),
              ),
              ElevatedButton.icon(
                onPressed: () => authRepository.signIn(),
                icon: SvgPicture.asset('assets/images/google.svg', width: 24),
                label: Text(AppLocalizations.of(context)!.signInGoogle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
