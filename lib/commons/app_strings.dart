import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String ksHomeBottomSheetTitle = 'Build Great Apps!';
const String ksHomeBottomSheetDescription =
    'Stacked is built to help you build better apps. Give us a chance and we\'ll prove it to you. Check out stacked.filledstacks.com to learn more';

 TextStyle heading = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
      color: Colors.black,
);
 TextStyle heading1 = TextStyle(
   
    fontSize: 22.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
);
 TextStyle heading2 = TextStyle(
    fontSize: 18.sp,
      color: Colors.black,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis 
);

 TextStyle heading3 = TextStyle(
      color: Colors.black,
    fontSize: 18.sp,
    overflow: TextOverflow.ellipsis 
);
 TextStyle heading4 = TextStyle(
      color: Colors.black,
    fontSize: 18.sp,
    overflow: TextOverflow.ellipsis 
);
TextStyle myStyle(double size,[Color? color,FontWeight fw = FontWeight.w700])
  {
    return TextStyle(
     fontSize: size,
     fontWeight:  fw,
     color: color,
   );
  }

