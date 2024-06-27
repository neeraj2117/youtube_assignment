import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube/app/providers/app_provider.dart';
import 'package:youtube/app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Core());
}

class Core extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: App(),
      providers: AppProvider.providers,
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.loginRoute,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
