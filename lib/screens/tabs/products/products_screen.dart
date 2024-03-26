import 'package:firebase_messaging/firebase_messaging.dart';
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

  _init() async {
    FirebaseMessaging.instance.subscribeToTopic("news");

    FirebaseMessaging.instance.unsubscribeFromTopic("news");

    String? fcmTome = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM TOKEN:$fcmTome");
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification != null) {
        LocalNotificationService().showNotification(
          title: remoteMessage.notification!.title!,
          body: remoteMessage.notification!.body!,
          id: id,
        );
      }
      debugPrint(
          "FOREGROUND MODE DA PUSH NOTIFICATION KELDI:${remoteMessage.notification!.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification != null) {
        debugPrint(
            "TERMINATED MODE DA PUSH NOTIFICATION KELDI:${remoteMessage.notification!.title}");
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

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
          children: [],
        ));
  }
}
