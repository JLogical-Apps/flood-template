import 'package:flutter/material.dart';
import 'package:flood/flood.dart';
import 'package:template/presentation/pages/login_page.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().withRedirect((context, route) async {
        final loggedInUserId = context.authCoreComponent.loggedInUserId;
        if (loggedInUserId == null) {
          return LoginRoute().routeData;
        }
        return null;
      });

  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    return StyledPage(
      titleText: 'Hello',
      actions: [
        ActionItem(
          titleText: 'Log Out',
          descriptionText: 'Log out of your account',
          iconData: Icons.logout,
          color: Colors.red,
          onPerform: (context) async {
            await context.authCoreComponent.logout();
            context.warpTo(LoginRoute());
          },
        ),
      ],
      body: StyledList.column.withScrollbar(
        children: [
          StyledText.body(loggedInUserId ?? 'N/A'),
        ],
      ),
    );
  }
}
