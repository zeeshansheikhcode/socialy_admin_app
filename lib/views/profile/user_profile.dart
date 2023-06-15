import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commons/app_strings.dart';
import '../../commons/ui_helpers.dart';
import '../../cubit/user/user_cubit.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UserCubit>(context).getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
      
        },
        builder: (context, state) {
          if(state is UserLoadingState)
          {
             return const Center(child: CircularProgressIndicator.adaptive(),);
          }
          if(state is UserLoadedState)
          {
             return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpaceMassive,
              Center(
                  child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child:  CircleAvatar(
                  backgroundColor: Colors.blue,
                  maxRadius: 50,
                  foregroundImage: NetworkImage(state.userModel!.photoUrl!),
                
                ),
              )),
              verticalSpaceTiny,
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<UserCubit>(context).pickImage();
                  },
                  child: Text(
                    "Edit Pictures",
                    style: heading,
                  )),
              verticalSpaceMedium,
              Center(
                child: Text(
                  state.userModel!.name!,
                  style: heading,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
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
                            controller: nameController,
                            decoration:
                                const InputDecoration(hintText: 'Edwards'),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Submit'),
                              onPressed: () {
                                BlocProvider.of<UserCubit>(context)
                                    .changeName(nameController.text);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Edit Name",
                    style: heading,
                  )
                ),
                
                verticalSpaceRegular,
                if(state.userModel!.followers!.isNotEmpty) 
                ...[
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Align( 
                      alignment: Alignment.centerLeft,
                      child: Text(
                        textAlign: TextAlign.left,
                        "Followers List",
                        style: heading,
                        ),
                    ),
                  ),
                Expanded(
                child: ListView.builder(
                 itemCount: state.userModel!.followers!.length,
                 itemBuilder: (context,index) 
                  {
                     return 
                     SizedBox(
                      height: 30,
                       child: ListTile(
                       title: Text(state.userModel!.followers![index].toString(), 
                       style: heading,
                       ),
                       trailing: TextButton(
                        onPressed: ()
                        {
                          BlocProvider.of<UserCubit>(context).deleteFollowers(state.userModel!.followers![index].toString());
                        },
                        child: const Text('Unfollow',style: TextStyle(color:Colors.black),), 
                       ),
                                        ),
                     );
                  }
                 )
              )
                ]
               
              
                
              
                
            ],
          );
          }
         return const SizedBox();
        },
      ),
    );
  }
}
