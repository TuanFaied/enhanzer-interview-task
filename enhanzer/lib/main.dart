import 'package:enhanzer/screen/task_list_screen.dart';
import 'package:enhanzer/service/task_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => TaskViewModel()),
    ],
    child:const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanzer',
      debugShowCheckedModeBanner: false,
      
      home: TaskListScreen(),
    );
  }
}