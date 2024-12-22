import 'package:flutter/material.dart';
import '../../widgets/articleinfo/articleinfo.dart';

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = ArticleInfo(
      title: 'Important Things to Know When Visiting the United States',
      difficulty: 2.5,
      paragraphs: [
        "Hello everyone! Imagine you are about to go on a very exciting trip to the United States! It’s a big and wonderful country, full of amazing places and people. But before you pack your bags and get on the plane, there are some important things you should know. Think of them as special rules to help keep your trip safe and fun.",
        "Firstly, you will need a very important document called a passport. This is like your official travel book that shows who you are. Your passport will have your picture and important details about you. Make sure it is up to date and not too old, or you might not be allowed to travel. You’ll need to show this to the people at the airport, so always keep it in a safe place.",
        "Another important thing to have is a visa. Depending on where you live, you might need a special permission slip to visit the United States. This is like a special invitation that the U.S. government gives to people from other countries. Your parents or guardians will need to check if you need one and how to get it. This is very important, so don’t forget to ask your grown-ups about it.",
        "When you arrive at the airport in the United States, you’ll meet some friendly people called customs officers. They are there to make sure everyone entering the country follows the rules. They might ask you some questions about your trip, like why you are visiting and how long you plan to stay. It’s important to answer them politely and honestly. They might also ask to look through your bags to make sure you are not bringing in anything you shouldn't.",
        "Another very important rule is to always listen to your parents or guardians. They are there to keep you safe, just like they are at home. If they tell you to stay close by, or not to talk to strangers, please listen carefully. They have your best interest at heart and they want you to have the most wonderful trip possible.",
        "The United States has a different type of money than many other countries. It’s called the US dollar. You will need to have some US dollars to buy things like food, souvenirs, and special treats. Before you leave, you might want to exchange some of your own money for US dollars, so you’re ready to go shopping when you get there.",
        "It’s also useful to know some very common English words, like 'hello,' 'please,' 'thank you,' and 'excuse me.' Using these words can be very helpful when you are talking to people. Many people in the United States are very kind and happy to help visitors.",
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('文章列表'),
      ),
      body: ListView(
        children: [
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
          article.buildTile(context),
        ],
      ),
    );
  }
} 