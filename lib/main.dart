import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gadget_shop/screens/permissions/permissions_screen.dart';
import 'package:gadget_shop/screens/routes.dart';
import 'package:gadget_shop/services/local_notification_service.dart';
import 'package:gadget_shop/utils/permission_utils/app_permissions.dart';
import 'package:gadget_shop/view_models/auth_view_model.dart';
import 'package:gadget_shop/view_models/category_view_model.dart';
import 'package:gadget_shop/view_models/image_view_model.dart';
import 'package:gadget_shop/view_models/products_view_model.dart';
import 'package:gadget_shop/view_models/tab_view_model.dart';
import 'package:gadget_shop/view_models/users_view_model.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "BACKGROUND MODE DA PUSH NOTIFICATION KELDI:${message.notification!.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureLocalTimeZone();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AppPermissions.getSomePermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => ProductsViewModel()),
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        ChangeNotifierProvider(create: (_) => ImageViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.localNotificationService.init(navigatorKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: PermissionsScreen(),
      initialRoute: RouteNames.splashScreen,
      navigatorKey: navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
