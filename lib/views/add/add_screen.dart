import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commons/app_strings.dart';
import '../../commons/ui_helpers.dart';
import '../../components/reusable_button.dart';
import '../../cubit/status_post_cubit.dart';
import '../home/widgets/post_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final statusTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  BlocProvider.of<StatusPostCubit>(context).getPosts();
    BlocProvider.of<StatusPostCubit>(context).getStoriePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpaceMassive,
          Center(
              child: Text(
            'Add Status',
            style: heading,
          )),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableButton(
                title: 'Text',
                height: 50.h,
                width: 60.w,
                circular: 10,
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Enter Status',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        content: TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: statusTextController,
                          decoration: const InputDecoration(hintText: 'Happy'),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              BlocProvider.of<StatusPostCubit>(context)
                                  .uploadStatus(statusTextController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ReusableButton(
                title: 'Photo',
                height: 50.h,
                width: 60.w,
                circular: 10,
                ontap: () {
                  BlocProvider.of<StatusPostCubit>(context)
                      .pickImage(isStatus: true);
                },
              ),
              ReusableButton(
                title: 'Video',
                height: 50.h,
                width: 60.w,
                circular: 10,
              ),
            ],
          ),
          verticalSpaceSmall,
          Center(
              child: Text(
            'Post',
            style: heading,
          )),
          verticalSpaceSmall,
          ReusableButton(
            title: 'Add',
            height: 50.h,
            width: 60.w,
            circular: 10,
            ontap: () {
              BlocProvider.of<StatusPostCubit>(context)
                  .pickImage(isStatus: false);
            },
          ),
          verticalSpaceSmall,
          Center(child: Text('Tap on Post to delete ',style: heading,),),
          verticalSpaceTiny,
          Expanded(
            child: BlocConsumer<StatusPostCubit, StatusPostState>(
              listener: (context, state) {
              },
              builder: (context, state) {
                if(state is StatusPostLoadedState)
                {
                   return ListView.builder(
                    itemCount: BlocProvider.of<StatusPostCubit>(context).posts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: ()
                        {
                           BlocProvider.of<StatusPostCubit>(context).deletePosts(state.allPost![index]); 
                        },
                        child: PostWidget(
                        postModel: state.allPost![index]),
                      );
                    });
                 }
                  return const SizedBox();
                }
            ),
          ),
        ],
      ),
    );
  }
}
