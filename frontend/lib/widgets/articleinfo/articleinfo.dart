import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleInfo extends StatelessWidget {
  final String title;
  final double difficulty;
  final String id;
  final List<String> paragraphs;

  const ArticleInfo({
    super.key,
    required this.title,
    required this.difficulty,
    required this.id,
    this.paragraphs = const [],
  }) : assert(difficulty >= 1 && difficulty <= 5);

  Future<Map<String, dynamic>> fetchArticleContent() async {
    final response = await http.get(
      Uri.parse('https://linguaboost.uroi.xyz/articles/$id.json'),
    );

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = json.decode(decodedBody);
      if (data['content'] is String) {
        data['content'] = (data['content'] as String)
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
      }
      return data;
    } else {
      throw Exception('Failed to load article content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 81,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '難度：',
                        style: TextStyle(
                          fontSize: 63,
                          color: Colors.grey,
                        ),
                      ),
                      DifficultyStars(difficulty: difficulty, size: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          subtitle: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('難度: '),
                  DifficultyStars(difficulty: difficulty, size: 16),
                ],
              ),
            ],
          ),
          onTap: () async {
            final contents = await fetchArticleContent();
            Navigator.of(context).pushNamed(
              '/content',
              arguments: {
                'title': title,
                'difficulty': difficulty,
                'paragraphs': contents['content'],
              },
            );
          },
        ),
      ),
    );
  }
}

class DifficultyStars extends StatelessWidget {
  final double difficulty;
  final double size;

  const DifficultyStars({
    super.key,
    required this.difficulty,
    this.size = 32,
  }) : assert(difficulty >= 1 && difficulty <= 5);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index < difficulty.floor()) {
          return Icon(Icons.star, color: const Color(0xFFFFD700), size: size);
        } else if (index == difficulty.floor() && difficulty % 1 != 0) {
          return Icon(Icons.star_half, color: const Color(0xFFFFD700), size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.grey, size: size);
        }
      }),
    );
  }
}