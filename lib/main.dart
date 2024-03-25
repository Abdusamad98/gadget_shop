import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gadget_shop/screens/routes.dart';
import 'package:gadget_shop/services/local_notification_service.dart';
import 'package:gadget_shop/view_models/auth_view_model.dart';
import 'package:gadget_shop/view_models/category_view_model.dart';
import 'package:gadget_shop/view_models/products_view_model.dart';
import 'package:gadget_shop/view_models/tab_view_model.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => ProductsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    LocalNotificationService.localNotificationService.init(navigatorKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: RouteNames.splashScreen,
      navigatorKey: navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
