import 'package:flutter/material.dart';
import 'package:socialyadmin/utils/routes/routes_name.dart';

import '../../views/add/add_screen.dart';
import '../../views/auth/login/login_screen.dart';
import '../../views/auth/signup/signup_screen.dart';
import '../../views/home/home/home_view.dart';
import '../../views/splash_screen.dart';
class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings)
  {

    switch(settings.name)
    {

      case RoutesName.splashview :
        return MaterialPageRoute(builder: (BuildContext context)  =>   const SplashScreen());
      case RoutesName.signupview :
        return MaterialPageRoute(builder: (BuildContext context)  =>    const SignupScreen());
     case RoutesName.loginview :
        return MaterialPageRoute(builder: (BuildContext context)  =>    const LoginScreen());
     case RoutesName.homeView :
        return MaterialPageRoute(builder: (BuildContext context)  =>    const HomeView());
       case RoutesName.addview :
        return MaterialPageRoute(builder: (BuildContext context)  => const  AddScreen());
   
     default:

        return MaterialPageRoute(builder: (_)
        {
          return const Scaffold(
            body: Center(
              child: Text('No routes Defined'),
            ),
          );
        });
    }
  }
}