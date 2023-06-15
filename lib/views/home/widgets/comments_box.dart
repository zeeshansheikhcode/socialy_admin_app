import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commons/ui_helpers.dart';
import '../../../models/post_model.dart';
class CommentBox extends StatelessWidget {
  final Comment comments;
  const CommentBox({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
      height: 70.h,
      width: 0.6.sw,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [ verticalSpaceTiny,
          Text(comments.username,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
         ),
          verticalSpaceTiny,
          Text(comments.comment,
          maxLines: 3, 
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),)

        ],
      ),
    );
  }
}