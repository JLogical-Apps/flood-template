import 'package:flood/flood.dart';
import 'package:template/presentation/pages/home_page.dart';
import 'package:template/presentation/pages/login_page.dart';
import 'package:template_core/features/user/user_entity.dart';

extension RedirectAppPageExtensions<R extends Route> on AppPage<R> {
  AppPage<R> onlyIfLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.authCoreComponent.loggedInUserId;
      if (loggedInUserId == null) {
        return LoginRoute().routeData;
      }

      return null;
    });
  }

  AppPage<R> onlyIfNotLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.authCoreComponent.loggedInUserId;
      if (loggedInUserId != null) {
        return HomeRoute().routeData;
      }

      return null;
    });
  }

  AppPage<R> onlyIfAccountExists() {
    return onlyIfLoggedIn().withRedirect((context, route) async {
      final loggedInUserId = context.authCoreComponent.loggedInUserId;
      final userEntity = await Query.getByIdOrNull<UserEntity>(loggedInUserId!).get(context.dropCoreComponent);
      if (userEntity == null) {
        return LoginRoute().routeData;
      }

      return null;
    });
  }
}
