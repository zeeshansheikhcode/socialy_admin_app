import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commons/app_strings.dart';
import '../../../commons/ui_helpers.dart';
import '../../../cubit/status_post_cubit.dart';
import '../../../models/post_model.dart';
import '../home/home_view.dart';
import '../widgets/comments_box.dart';
class CommentsView extends StatefulWidget {
  final PostModel postModel;
  const CommentsView({super.key,required this.postModel});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final commentsTextController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StatusPostCubit>(context).getComments(widget.postModel);
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swiped downwards
          Navigator.pop(context);
        }
        };
      },
      child: Scaffold(
        body: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.vertical,
          onDismissed: (_) {
            // Swiped downwards
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeView()));
          },
          child: BlocConsumer<StatusPostCubit, StatusPostState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                  [ 
                    verticalSpaceRegular,
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                      child: Text('Comments',style: heading1,),
                     )
                    ),
                    state is CommentsLoadedState ?
                     Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: 0.6.sw,
                        child: ListView.builder( 
                          itemCount: state.allComments!.length,
                          itemBuilder: (context,index)
                          {    
                              return  CommentBox(comments: state.allComments![index]);   
                          }
                         ),
                      )
                      )
                    :
                    const Expanded(
                      flex: 3,
                      child: SizedBox()),
                    
                     Expanded(
                      flex: 1,
                      child: Container(
                                height: 70.h,
                                color: Colors.white,
                                child:Row(
                                  children:  [
                                     Expanded(
                                       child: TextField(
                                        style: const TextStyle(color: Colors.black),
                                        controller: commentsTextController,
                                        decoration:const InputDecoration(
                                          hintText: 'Type your message here',
                                          border: InputBorder.none,
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16.0),
                                        ),
                                       ),
                                     ),
                                    
                                    IconButton
                                    (
                                    onPressed: ()
                                    {     
                                       BlocProvider.of<StatusPostCubit>(context).onSendComment(widget.postModel,commentsTextController.text);
                                       commentsTextController.clear();
                                    },
                                    icon:const Icon(Icons.send))
                                  ],
                                ),
                              ),)
                  ],
                );
            },
          ),
        ),
      ),
    );
  }
}