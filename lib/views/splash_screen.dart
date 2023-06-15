import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialyadmin/views/splash_services.dart';

import '../utils/routes/routes_name.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),
     () async
     {  
       //Navigator.pushNamed(context   , RoutesName.loginview);
      SplashService splashService = SplashService();
        dynamic auth = await splashService.checkingAuthentication();
       
       if(auth == true) 
        {  
          // Navigator.push(context  , MaterialPageRoute(builder: (context)=> const AddScreen()));
           Navigator.pushReplacementNamed(context  , RoutesName.homeView);
        }
        else 
        {
           Navigator.pushReplacementNamed(context   , RoutesName.loginview);
        }
     });
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Center(child: Text('Admin Socialy',
           style: TextStyle(
            color: Colors.black,
            fontSize: 25.sp,
           )
           )),
          SizedBox(height: 10.h,), 
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            height: 200.h,
            width: 200.w,
            child:const Center(
              child: Image(image: AssetImage('assets/images/splashimg.png')) ,
            ),
          ),
        ],
      ),
    );
  }
}