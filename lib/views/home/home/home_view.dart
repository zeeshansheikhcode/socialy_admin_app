import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialyadmin/views/home/widgets/status_widget.dart';

import '../../../commons/ui_helpers.dart';
import '../../../components/reusable_button.dart';
import '../../../cubit/status_post_cubit.dart';
import '../widgets/post_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StatusPostCubit>(context).getStoriePosts();
    // BlocProvider.of<StatusPostCubit>(context).getPosts();
    // BlocProvider.of<StatusPostCubit>(context).getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        verticalSpaceSmall,

        BlocBuilder<StatusPostCubit, StatusPostState>(
          builder: (context, state) {
            if (state is StatusPostLoadingState) {
              return  SizedBox(
                height: 120.h,
                child: 
                const Center(
                  child: CircularProgressIndicator.adaptive()));
            }
            return SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: BlocProvider.of<StatusPostCubit>(context)
                    .uniqueEmail
                    .length,
                itemBuilder: ((context, index) {
                  return StatusWidget(
                    allStories: BlocProvider.of<StatusPostCubit>(context)
                        .allStories[index],
                  );
                }),
              ),
            );
          },
        ),
        verticalSpaceTiny,
        BlocBuilder<StatusPostCubit, StatusPostState>(
          builder: (context, state) {
            if (state is StatusPostLoadingState) {
              return const SizedBox(
                child: 
                Center(
                  child: CircularProgressIndicator.adaptive()));
            }
            return Expanded(
              child: SizedBox(
                 height: 0.7.sh,
                child: ListView.builder(
                  itemCount:
                      BlocProvider.of<StatusPostCubit>(context).posts.length,
                  itemBuilder: (context, index) {
                    return PostWidget(
                      postModel: BlocProvider.of<StatusPostCubit>(context)
                          .posts[index],
                    );
                  },
                ),
              ),
            );
          },
        ),
        verticalSpaceSmall,
        SizedBox(
          height: 50.h,
          child: ReusableButton(
          title: 'Add Post',
          height: 50.h,
          width: 0.5.sw,
          circular: 10,
          ontap: () {
            BlocProvider.of<StatusPostCubit>(context)
                .pickImage(isStatus: false);
          },
            ),
        ),
        verticalSpaceSmall,
      ],
    ));
  }
}
