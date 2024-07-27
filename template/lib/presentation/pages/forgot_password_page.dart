import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ForgotPasswordRoute with IsRoute<ForgotPasswordRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('forgot-password');

  @override
  ForgotPasswordRoute copy() => ForgotPasswordRoute();
}

class ForgotPasswordPage with IsAppPage<ForgotPasswordRoute> {
  @override
  Widget onBuild(BuildContext context, ForgotPasswordRoute route) {
    final emailPort = useMemoized(() => Port.of({
          'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
        }).map((values, port) => values['email'] as String));

    return StyledPage(
      titleText: 'Forgot Password',
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledCard(
            titleText: 'Reset Password',
            bodyText: 'Enter your email address to reset your password.',
            leadingIcon: Icons.lock_reset,
            children: [
              StyledObjectPortBuilder(port: emailPort),
            ],
          ),
          StyledButton.strong(
            labelText: 'Send Reset Email',
            onPressed: () async {
              final result = await emailPort.submit();
              if (!result.isValid) {
                return;
              }

              final email = result.data; // This is a String due to the way we defined the Port.

              try {
                await context.authCoreComponent.resetPassword(email);
                context.showStyledMessage(StyledMessage(
                  labelText: 'Reset email sent. Check your inbox!',
                ));
              } catch (error, stackTrace) {
                context.showStyledMessage(StyledMessage.error(labelText: error.toString()));
                context.logError(error, stackTrace);
              }
            },
          ),
        ],
      ),
    );
  }
}
