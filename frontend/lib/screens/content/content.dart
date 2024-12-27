import 'package:flutter/material.dart';
import '../../widgets/content/content.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = args['title'] as String;
    final List<String> articleParagraphs = args['paragraphs'] as List<String>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          overflow: TextOverflow.visible,
          maxLines: 2,
          softWrap: true,
          style: const TextStyle(
            height: 1.2,
          ),
        ),
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AdvancedParagraphReadingWidget(
          paragraphs: articleParagraphs,
          readColor: Colors.black87,
          unreadColor: Colors.grey.shade400,
          paragraphSpacing: 24.0,
        ),
      ),
    );
  }
}
