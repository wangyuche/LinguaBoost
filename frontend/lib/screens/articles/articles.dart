import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../widgets/articleinfo/articleinfo.dart';

String getYearAndWeek({int weeksAgo = 0}) {
  final now = DateTime.now();
  final targetDate = now.subtract(Duration(days: 7 * weeksAgo));
  final firstDayOfYear = DateTime(targetDate.year, 1, 1);
  final weekNumber = ((targetDate.difference(firstDayOfYear).inDays + firstDayOfYear.weekday - 1) / 7).ceil();
  
  return '${targetDate.year}$weekNumber.json';
}

Future<List<ArticleInfo>> fetchArticles() async {
  List<ArticleInfo> allArticles = [];
  
  // 獲取最近三週的文章
  for (int i = 0; i < 4; i++) {
    final filename = getYearAndWeek(weeksAgo: i);
    try {
      final response = await http.get(
        Uri.parse('https://linguaboost.uroi.xyz/$filename'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> articles = jsonData['Data'];
        
        allArticles.addAll(articles.map((article) => ArticleInfo(
          title: article['title'],
          difficulty: article['difficulty'].toDouble(),
          id: article['id'],
          paragraphs: [],
        )));
      }
    } catch (e) {
      print('Failed to fetch articles for week $i: $e');
      // 繼續執行，即使某一週的數據獲取失敗
      continue;
    }
  }
  
  if (allArticles.isEmpty) {
    throw Exception('Failed to load any articles');
  }
  
  return allArticles;
}

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late Future<List<ArticleInfo>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文章列表'),
      ),
      body: FutureBuilder<List<ArticleInfo>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index].buildTile(context);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
} 