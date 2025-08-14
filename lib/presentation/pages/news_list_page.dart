import 'package:flutter/material.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top headlines')),
      body: const Center(child: Text('Here will be the news list')),
    );
  }
}
