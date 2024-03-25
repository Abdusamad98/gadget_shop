import 'package:flutter/material.dart';
import 'package:gadget_shop/data/models/product_model.dart';
import 'package:gadget_shop/services/local_notification_service.dart';
import 'package:gadget_shop/view_models/products_view_model.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
          actions: [
            IconButton(
              onPressed: () {
                context.read<ProductsViewModel>().insertProducts(
                      ProductModel(
                        price: 12.5,
                        imageUrl:
                            "https://i.ebayimg.com/images/g/IUMAAOSwZGBkTR-K/s-l400.png",
                        productName: "Nokia 12 80",
                        docId: "",
                        productDescription: "productDescription",
                        categoryId: "kcggCJzOEz7gH1LQy44x",
                      ),
                      context,
                    );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            TextButton(
              child: const Text("Show Notification"),
              onPressed: () {
                LocalNotificationService().showNotification(
                  title: "Galaxy 12 nomli maxsulot qo'shildi!",
                  body: "Maxsulot haqida ma'lumot olishingiz mumkin.",
                  id: id,
                );
                id++;
              },
            ),
            TextButton(
              child: const Text("Cancel Notification"),
              onPressed: () {
                LocalNotificationService().cancelNotification(3);
              },
            ),
            TextButton(
              child: const Text("Show Periodic Notification"),
              onPressed: () {
                LocalNotificationService().scheduleNotification(
                  title: "Galaxy 12 nomli maxsulot qo'shildi!",
                  body: "Maxsulot haqida ma'lumot olishingiz mumkin.",
                  delayedTime: 5,
                );
              },
            ),
          ],
        ));
  }
}
