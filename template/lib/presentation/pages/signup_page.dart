import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:template/presentation/pages/home_page.dart';
import 'package:template/presentation/pages/login_page.dart';
import 'package:template/utils/route_utils.dart';
import 'package:template_core/features/user/user.dart';
import 'package:template_core/features/user/user_entity.dart';

class SignupRoute with IsRoute<SignupRoute> {
  late final initialEmailProperty = field<String>(name: 'initialEmail');
  late final initialPasswordProperty = field<String>(name: 'initialPassword');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('signup');

  @override
  List<RouteProperty> get hiddenProperties => [initialEmailProperty, initialPasswordProperty];

  @override
  SignupRoute copy() {
    return SignupRoute();
  }
}

class SignupPage with IsAppPageWrapper<SignupRoute> {
  @override
  AppPage<SignupRoute> get appPage =>
      AppPage<SignupRoute>().onlyIfNotLoggedIn().withParent((context, route) => LoginRoute());

  @override
  Widget onBuild(BuildContext context, SignupRoute route) {
    final signupPort = useMemoized(() => Port.of({
          'name': PortField.string().withDisplayName('Name').isNotBlank().isName(),
          'email': PortField.string(initialValue: route.initialEmailProperty.value)
              .withDisplayName('Email')
              .isNotBlank()
              .isEmail(),
          'password': PortField.string(initialValue: route.initialPasswordProperty.value)
              .withDisplayName('Password')
              .isNotBlank()
              .isPassword(),
          'confirmPassword': PortField.string()
              .withDisplayName('Confirm Password')
              .isNotBlank()
              .isConfirmPassword(passwordField: 'password'),
        }));

    return StyledPage(
      titleText: 'Signup',
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledCard(
            titleText: 'Info',
            bodyText: 'Fill in your information to get started!',
            leadingIcon: Icons.person,
            children: [
              StyledObjectPortBuilder(port: signupPort),
            ],
          ),
          StyledButton.strong(
            labelText: 'Sign Up',
            onPressed: () async {
              final result = await signupPort.submit();
              if (!result.isValid) {
                return;
              }

              final data = result.data;

              try {
                final account = await context.authCoreComponent
                    .signup(AuthCredentials.email(email: data['email'], password: data['password']));

                await context.dropCoreComponent.updateEntity(UserEntity()
                  ..id = account.accountId
                  ..set(User()
                    ..nameProperty.set(data['name'])
                    ..emailProperty.set(data['email'])));

                context.warpTo(HomeRoute());
              } catch (e, stackTrace) {
                final errorText = e.as<SignupFailure>()?.displayText ?? e.toString();
                signupPort.setError(path: 'email', error: errorText);
                context.logError(e, stackTrace);
              }
            },
          ),
        ],
      ),
    );
  }
}
