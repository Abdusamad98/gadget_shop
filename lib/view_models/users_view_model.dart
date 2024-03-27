import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadget_shop/data/models/user_model.dart';
import 'package:gadget_shop/utils/constants/app_constants.dart';
import 'package:gadget_shop/utils/utility_functions.dart';

class UsersViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get getLoader => _isLoading;

  List<UserModel> categories = [];

  Future<void> getAllUsers() async {
    _notify(true);
    await FirebaseFirestore.instance
        .collection(AppConstants.users)
        .get()
        .then((snapshot) {
      categories =
          snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
    });
    _notify(false);
  }

  Stream<List<UserModel>> listenUsers() => FirebaseFirestore.instance
      .collection(AppConstants.users)
      .snapshots()
      .map(
        (event) => event.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList(),
      );
  updateUserModel(UserModel userModel, BuildContext context) async {
    try {
      _notify(true);
      await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(userModel.userDocId)
          .update(userModel.toJsonForUpdate());

      _notify(false);
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      showSnackbar(
        context: context,
        message: error.code,
      );
    }
  }

  deleteUser(String docId, BuildContext context) async {
    try {
      _notify(true);
      await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(docId)
          .delete();

      _notify(false);
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      showSnackbar(
        context: context,
        message: error.code,
      );
    }
  }

  _notify(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
