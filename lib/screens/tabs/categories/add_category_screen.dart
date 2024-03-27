import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gadget_shop/data/models/category_model.dart';
import 'package:gadget_shop/utils/size/size_utils.dart';
import 'package:gadget_shop/utils/styles/app_text_style.dart';
import 'package:gadget_shop/view_models/category_view_model.dart';
import 'package:gadget_shop/view_models/image_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  String imageUrl = "";
  String storagePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Catgeory"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            TextFormField(
              controller: categoryNameController,
              decoration: InputDecoration(
                labelText: "CATEGORY",
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
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(24),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                takeAnImage();
              },
              child: Text(
                "TAKE AN IMAGE",
                style: AppTextStyle.interSemiBold.copyWith(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (context.watch<ImageViewModel>().getLoader)
              const CircularProgressIndicator(),
            if (imageUrl.isNotEmpty) Image.network(imageUrl),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(24),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                if (imageUrl.isNotEmpty &&
                    categoryNameController.text.isNotEmpty) {
                  await context.read<CategoriesViewModel>().insertCategory(
                        CategoryModel(
                          storagePath: storagePath,
                          imageUrl: imageUrl,
                          categoryName: categoryNameController.text,
                          docId: "",
                        ),
                        context,
                      );

                  Navigator.pop(context);
                }
              },
              child: Text(
                "ADD CATEGORY",
                style: AppTextStyle.interSemiBold.copyWith(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null && context.mounted) {
      debugPrint("IMAGE PATH:${image.path}");
      storagePath = "files/images/${image.name}";
      imageUrl = await context.read<ImageViewModel>().uploadImage(
            pickedFile: image,
            storagePath: storagePath,
          );

      debugPrint("DOWNLOAD URL:$imageUrl");
    }
  }

  Future<void> _getImageFromGallery() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null && context.mounted) {
      debugPrint("IMAGE PATH:${image.path}");
      storagePath = "files/images/${image.name}";
      imageUrl = await context.read<ImageViewModel>().uploadImage(
            pickedFile: image,
            storagePath: storagePath,
          );

      debugPrint("DOWNLOAD URL:$imageUrl");
    }
  }

  takeAnImage() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        )),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              ListTile(
                onTap: () async {
                  await _getImageFromGallery();
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo_album_outlined),
                title: const Text("Gallereyadan olish"),
              ),
              ListTile(
                onTap: () async {
                  await _getImageFromCamera();
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kameradan olish"),
              ),
              SizedBox(height: 24.h),
            ],
          );
        });
  }
}
