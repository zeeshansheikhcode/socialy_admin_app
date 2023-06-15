import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commons/ui_helpers.dart';
import '../../../cubit/status_post_cubit.dart';
import '../../../models/story_model.dart';
import '../status/show_status_view.dart';

class StatusWidget extends StatelessWidget {
  final List<StoryModel> allStories;
  const StatusWidget({super.key, required this.allStories});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusPostCubit, StatusPostState>(
      listener: (context, state) {
     
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            print('Status Widget $state');
            if(state is StatusPostLoadedState)
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowStatus(
                          showstories: allStories,
                          username: allStories[0].username!,
                          image: allStories[0].profilePic!,
                        )));

            }
          },
          child: Container(
            height: 100.h,
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 CircleAvatar(
                  backgroundColor: Colors.blue,
                  maxRadius: 30,
                  foregroundImage: NetworkImage(allStories[0].profilePic!),
                ),
                verticalSpaceSmall,
                Text(allStories[0].username!,style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black
                ),),
                verticalSpaceSmall,
              ],
            ),
          ),
        );
      },
    );
  }
}
