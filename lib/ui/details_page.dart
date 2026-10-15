import 'package:flutter/material.dart';
import '../data/news_model.dart';

class DetailsPage extends StatelessWidget {
  final Article article;

  const DetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue.shade100,
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
                    )
                  : const Icon(Icons.image, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${article.source} • ${article.publishedAt.split('T').first}'),
            const SizedBox(height: 12),
            Text(article.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Read more: ${article.url}')),
                );
              },
              child: const Text('Read more'),
            ),
          ],
        ),
      ),
    );
  }
}