import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sugar_to_do/shared/cubit/bloc_observer.dart';

import 'home_layout.dart';
import 'package:timezone/data/latest.dart' as tzl;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tzl.initializeTimeZones();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sugar To Do',
      home: HomeLayout(),
    );
  }
}

