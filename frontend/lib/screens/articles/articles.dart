import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../widgets/articleinfo/articleinfo.dart';

String getYearAndWeek() {
  final now = DateTime.now();
  final firstDayOfYear = DateTime(now.year, 1, 1);
  final weekNumber = ((now.difference(firstDayOfYear).inDays + firstDayOfYear.weekday - 1) / 7).ceil();
  
  return '${now.year}$weekNumber.json';
}

Future<List<ArticleInfo>> fetchArticles() async {
  final filename = getYearAndWeek();
  final response = await http.get(Uri.parse('https://linguaboost.uroi.xyz/$filename'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> articles = jsonData['Data'];
    
    return articles.map((article) => ArticleInfo(
      title: article['title'],
      difficulty: article['difficulty'].toDouble(),
      id: article['id'],
      // 暫時使用空段落列表，你需要根據實際 JSON 結構調整
      paragraphs: [],
    )).toList();
  } else {
    throw Exception('Failed to load articles');
  }
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