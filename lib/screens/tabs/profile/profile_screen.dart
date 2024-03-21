import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gadget_shop/utils/size/size_utils.dart';
import 'package:gadget_shop/utils/styles/app_text_style.dart';
import 'package:gadget_shop/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<AuthViewModel>().getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthViewModel>().logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: user != null
          ? context.watch<AuthViewModel>().loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            user.uid,
                            style: AppTextStyle.interSemiBold
                                .copyWith(fontSize: 24),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            user.email.toString(),
                            style: AppTextStyle.interSemiBold
                                .copyWith(fontSize: 24),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            user.displayName.toString(),
                            style: AppTextStyle.interSemiBold
                                .copyWith(fontSize: 24),
                          ),
                          if (user.photoURL != null)
                            Image.network(
                              user.photoURL!,
                              width: 200,
                              height: 200,
                            ),
                          IconButton(
                            onPressed: () {
                              context.read<AuthViewModel>().updateImageUrl(
                                  "https://www.tenforums.com/attachments/tutorials/146359d1501443008-change-default-account-picture-windows-10-a-user.png");
                            },
                            icon: const Icon(Icons.image),
                          )
                        ],
                      ),
                    ),
                  ),
                )
          : const Center(
              child: Text("USER NOT EXIST"),
            ),
    );
  }
}
