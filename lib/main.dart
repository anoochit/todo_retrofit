import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_retrofit/pages/home.dart';

import 'services/todo.dart';

late RestClient client;
late Dio dio;

void main() {
  dio = Dio();
  client = RestClient(dio);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
