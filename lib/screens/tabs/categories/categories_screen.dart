import 'package:flutter/material.dart';
import 'package:gadget_shop/data/models/category_model.dart';
import 'package:gadget_shop/view_models/category_view_model.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CategoriesViewModel>().insertCategory(
                    CategoryModel(
                      imageUrl:
                          "https://static-assets.business.amazon.com/assets/in/24th-jan/705_Website_Blog_Appliances_1450x664.jpg.transform/1450x664/image.jpg",
                      categoryName: "Maishiy texnikalar",
                      docId: "",
                    ),
                    context,
                  );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: context.read<CategoriesViewModel>().listenCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            List<CategoryModel> list = snapshot.data as List<CategoryModel>;
            return ListView(
              children: [
                ...List.generate(
                  list.length,
                  (index) {
                    CategoryModel category = list[index];
                    return ListTile(
                      leading: Image.network(
                        category.imageUrl,
                        width: 50,
                      ),
                      title: Text(category.categoryName),
                      subtitle: Text(category.docId),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<CategoriesViewModel>()
                                    .deleteCategory(category.docId, context);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<CategoriesViewModel>()
                                    .updateCategory(
                                      CategoryModel(
                                        imageUrl:
                                            "https://dnr.wisconsin.gov/sites/default/files/feature-images/ECycle_Promotion_Manufacturers.jpg",
                                        categoryName: "Electronics",
                                        docId: category.docId,
                                      ),
                                      context,
                                    );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
