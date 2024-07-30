import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:template/presentation/pages/forgot_password_page.dart';
import 'package:template/presentation/pages/home_page.dart';
import 'package:template/presentation/pages/signup_page.dart';
import 'package:template/utils/route_utils.dart';

class LoginRoute with IsRoute<LoginRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('login');

  @override
  LoginRoute copy() => LoginRoute();
}

class LoginPage with IsAppPageWrapper<LoginRoute> {
  @override
  AppPage<LoginRoute> get appPage => AppPage<LoginRoute>().onlyIfNotLoggedIn();

  @override
  Widget onBuild(BuildContext context, LoginRoute route) {
    final loginPort = useMemoized(() => Port.of({
          'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
          'password': PortField.string().withDisplayName('Password').isNotBlank().isPassword(),
        }));

    return StyledPage(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: StyledList.column.centered.withScrollbar(
            children: [
              StyledImage.asset('assets/logo_foreground.png', width: 200, height: 200),
              StyledText.twoXl.strong.display('Welcome to Todo'),
              StyledText.body.display('Turning Chaos into Checked Boxes'),
              StyledDivider(),
              StyledObjectPortBuilder(port: loginPort),
              StyledList.row.centered.withScrollbar(
                children: [
                  StyledButton(
                    labelText: 'Login',
                    onPressed: () async {
                      final result = await loginPort.submit();
                      if (!result.isValid) {
                        return;
                      }

                      final data = result.data;

                      try {
                        final account = await context.authCoreComponent
                            .login(AuthCredentials.email(email: data['email'], password: data['password']));
                        print('Logged in: $account');

                        context.warpTo(HomeRoute());
                      } catch (e, stackTrace) {
                        final errorText = e.as<LoginFailure>()?.displayText ?? e.toString();
                        loginPort.setError(path: 'email', error: errorText);
                        context.logError(e, stackTrace);
                      }
                    },
                  ),
                  StyledButton.strong(
                    labelText: 'Sign Up',
                    onPressed: () async {
                      context.push(SignupRoute()
                        ..initialEmailProperty.set(loginPort['email'])
                        ..initialPasswordProperty.set(loginPort['password']));
                    },
                  ),
                ],
              ),
              StyledButton.subtle(
                labelText: 'Forgot Password?',
                isTextButton: true,
                onPressed: () {
                  context.push(ForgotPasswordRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
