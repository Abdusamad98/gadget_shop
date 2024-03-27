import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadget_shop/data/models/user_model.dart';
import 'package:gadget_shop/screens/routes.dart';
import 'package:gadget_shop/utils/constants/app_constants.dart';
import 'package:gadget_shop/utils/utility_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  User? get getUser => FirebaseAuth.instance.currentUser;

  registerUser(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
  }) async {
    if (AppConstants.emailRegExp.hasMatch(email) &&
        AppConstants.passwordRegExp.hasMatch(password)) {
      try {
        _notify(true);
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        }
        _addNewUserToList(userCredential);
        _notify(false);
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, RouteNames.tabRoute);
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        showErrorForRegister(e.code, context);
      } catch (error) {
        if (!context.mounted) return;
        showSnackbar(
          context: context,
          message: "Noma'lum xatolik yuz berdi:$error.",
        );
      }
    } else {
      showSnackbar(
        context: context,
        message: "Login yoki Parolni xato kiritdingiz!",
      );
    }
  }

  loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    if (AppConstants.emailRegExp.hasMatch(email) &&
        AppConstants.passwordRegExp.hasMatch(password)) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, RouteNames.tabRoute);
      } on FirebaseAuthException catch (err) {
        if (!context.mounted) return;
        showErrorForLogin(err.code, context);
      } catch (error) {
        if (!context.mounted) return;
        showSnackbar(
          context: context,
          message: "Noma'lum xatolik yuz berdi:$error.",
        );
      }
    } else {
      showSnackbar(
        context: context,
        message: "Login yoki Parolni xato kiritdingiz!",
      );
    }
  }

  logout(BuildContext context) async {
    _notify(true);
    await FirebaseAuth.instance.signOut();
    _notify(false);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.loginRoute);
  }

  updateUsername(String username) async {
    _notify(true);
    await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
    _notify(false);
  }

  updateImageUrl(String imagePath) async {
    _notify(true);
    try {
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imagePath);
    } catch (error) {
      debugPrint("ERROR:$error");
    }
    _notify(false);
  }

  _notify(bool v) {
    _isLoading = v;
    notifyListeners();
  }

//TODO 6
  Future<void> signInWithGoogle(BuildContext context,
      [String? clientId]) async {
    // Trigger the authentication flow
    _notify(true);

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(clientId: clientId).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    _notify(false);
    if (userCredential.user != null) {
      Navigator.pushReplacementNamed(context, RouteNames.tabRoute);
    }
  }

  _addNewUserToList(UserCredential userCredential) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (userCredential.user != null) {
      UserModel userModel = UserModel(
        imageUrl: userCredential.user!.photoURL ??
            "https://icons.iconarchive.com/icons/aha-soft/people/256/user-icon.png",
        email: userCredential.user!.email ?? "",
        fcmToken: fcmToken ?? "",
        username: userCredential.user!.displayName ?? "Falonchi Falonchiyev",
        phoneNumber: userCredential.user!.phoneNumber ?? "+998 000 00 00",
        userDocId: "",
        userId: userCredential.user!.uid,
      );
      var user = await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .add(userModel.toJson());
      await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(user.id)
          .update({"user_doc_id": user.id});
    }
  }
}
