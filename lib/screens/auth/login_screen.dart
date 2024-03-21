import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gadget_shop/screens/routes.dart';
import 'package:gadget_shop/utils/constants/app_constants.dart';
import 'package:gadget_shop/utils/size/size_utils.dart';
import 'package:gadget_shop/utils/styles/app_text_style.dart';
import 'package:gadget_shop/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: context.watch<AuthViewModel>().loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(24.w),
              child: ListView(
                children: [
                  Text(
                    "LOGIN",
                    style: AppTextStyle.interSemiBold.copyWith(
                      fontSize: 45,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "EMAIL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "PASSWORD",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(24),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      onPressed: () {
                        context.read<AuthViewModel>().loginUser(
                              context,
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      },
                      child: Text(
                        "LOGIN",
                        style: AppTextStyle.interSemiBold
                            .copyWith(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(24),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteNames.registerRoute,
                        );
                      },
                      child: Text(
                        "REGISTER",
                        style: AppTextStyle.interSemiBold
                            .copyWith(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(24),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthViewModel>().signInWithGoogle(context,
                            Platform.isAndroid ? null : AppConstants.clientID);
                      },
                      child: Text(
                        "LOGIN WITH GOOGLE",
                        style: AppTextStyle.interSemiBold
                            .copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
