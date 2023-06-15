
import 'package:flutter/material.dart';

class Utils
{
   static int appId =  1278810159; // enter your id
   static String appSignin = "e6379f96bde265d667952d69c3ad55cabefe53dca5d129efe91323c446d39aed" ;
   static  showSnackBar(String message,BuildContext context)
   {
     return ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
           backgroundColor: Colors.green,
           content: Text(message)),
     );
   }
}