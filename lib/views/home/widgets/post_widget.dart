import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commons/app_strings.dart';
import '../../../commons/ui_helpers.dart';
import '../../../components/reusable_button.dart';
import '../../../cubit/status_post_cubit.dart';
import '../../../models/post_model.dart';
import '../../../utils/utils.dart';
import '../comments/comments_view.dart';

class PostWidget extends StatelessWidget {
  final PostModel postModel;
  const PostWidget({super.key, required this.postModel,});

  @override
  Widget build(BuildContext context) {
    print(postModel.photoUrl);
    return BlocConsumer<StatusPostCubit,StatusPostState>(
      listener: (context, state) {
      
      },
      builder: (context, state) {
        if(state is StatusPostLoadingState)
        {
           return const Center(child: CircularProgressIndicator(),);
        }
      
        return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        height: 350.h,
        width: 1.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceTiny,
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  postModel.useremail!,
                  style: heading2
                ),
              ),
              verticalSpaceTiny,
            Center(
              child: SizedBox(
                height: 200.h,
                 width: 1.sw,
                child: Image(
                  image: NetworkImage(
                    postModel.photoUrl!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<StatusPostCubit>(context).likeAdded(postModel);
                      Utils.showSnackBar('Like Added', context);
                    },
                    icon: (state is LikesLoadedState) ? 
                     const Icon(Icons.favorite_outlined)
                     :
                     const Icon(Icons.favorite_border_outlined)

                    
                     ),
                horizontalSpaceSmall,
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentsView(
                    postModel: postModel,
                  )));
                }, icon: const Icon(Icons.comment))
              ],
            ),
           Text( 
                  'Likes ${ (state is LikesLoadedState) ? state.allPostLikes!.likes!.length : 0} ',
                  style: heading3,
                ),
                verticalSpaceTiny,
               Center(child: ReusableButton(
            title: 'Delete',
            height: 50.h,
            width: 0.5.sw,
            circular: 10,
            ontap: () {
              BlocProvider.of<StatusPostCubit>(context)
                  .deletePosts(postModel);
            },
              ),)
          ],

        ),
              );
       
        //  return const SizedBox();
          
        }
        
    );
  }
}
