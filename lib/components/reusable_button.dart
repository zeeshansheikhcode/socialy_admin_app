import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ReusableButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final Color? color;
  final double? circular;
  final void Function()? ontap;  
  const ReusableButton({
    super.key,
     this.height,
     this.width, 
     this.title, 
     this.color = Colors.purple,
     this.circular = 25,
     this.ontap 
     });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
       margin: EdgeInsets.symmetric(horizontal: 10.w),
       height: height,
       width: width,
       decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(circular!)
       ),
       child: Center(
        child: Text(title!),
       ),
      ),
    );
  }
}