import 'package:A.N.R/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
              SvgPicture.asset('assets/images/logo.svg', width: 104),
              Container(
                margin: const EdgeInsets.only(top: 48, bottom: 24),
                child: Column(
                  children: [
                    Text(
                      'Bem-vindo!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Faça o login abaixo e aprovei a sua leitura!',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              SignInButton(
                Buttons.Google,
                text: 'Entrar com o Google',
                onPressed: () => AuthService.signIn().catchError((error) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error),
                  ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
