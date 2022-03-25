import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:users_app/screens/home_screen.dart';
import 'package:users_app/screens/user_screen.dart';
import 'package:users_app/services/user_service.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserService())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users App',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        'user': (_) => UserScreen(),
      },
    );
  }
}
