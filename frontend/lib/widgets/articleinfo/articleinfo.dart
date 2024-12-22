import 'package:flutter/material.dart';

class ArticleInfo extends StatelessWidget {
  final String title;
  final double difficulty;
  final List<String> paragraphs;

  const ArticleInfo({
    super.key,
    required this.title,
    required this.difficulty,
    this.paragraphs = const [],
  }) : assert(difficulty >= 1 && difficulty <= 5);

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
          Row(
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
        ],
      ),
    );
  }

  Widget buildTile(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
      subtitle: Row(
        children: [
          const Text('難度: '),
          DifficultyStars(difficulty: difficulty, size: 16),
        ],
      ),
      onTap: () => Navigator.of(context).pushNamed(
        '/content',
        arguments: {
          'title': title,
          'difficulty': difficulty,
          'paragraphs': paragraphs,
        },
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