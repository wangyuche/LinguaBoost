import 'package:flutter/material.dart';
import 'screens/articles/articles.dart';
import 'screens/content/content.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ArticlesScreen(),
        '/articles': (context) => ArticlesScreen(),
        '/content': (context) =>  ContentScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首頁'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/articles');
          },
          child: const Text('查看文章列表'),
        ),
      ),
    );
  }
}
