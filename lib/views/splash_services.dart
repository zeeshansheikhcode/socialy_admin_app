import 'package:shared_preferences/shared_preferences.dart';

class SplashService 
{
  Future<bool> checkingAuthentication() async
  {
    SharedPreferences sp  = await SharedPreferences.getInstance();
    final email = sp.getString('email');
    print(email);
    if(email != null && email.isNotEmpty)
    {
      return true;
    }
    else 
    {
      return false;
    }
  }
}