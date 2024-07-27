import 'package:flood/flood.dart';
import 'package:template/presentation/pages/forgot_password_page.dart';
import 'package:template/presentation/pages/home_page.dart';
import 'package:template/presentation/pages/login_page.dart';
import 'package:template/presentation/pages/signup_page.dart';

class PagesAppPondComponent with IsAppPondComponent {
  @override
  Map<Route, AppPage> get pages => {
        HomeRoute(): HomePage(),
        LoginRoute(): LoginPage(),
        SignupRoute(): SignupPage(),
        ForgotPasswordRoute(): ForgotPasswordPage(),
      };
}
