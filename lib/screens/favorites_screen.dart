import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quote_model.dart';
import '../providers/auth_provider.dart';
import '../services/quotes_service.dart';
import '../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final service = QuotesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Quotes')),
      body: StreamBuilder<List<Quote>>(
        stream: service.watchFavorites(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final quotes = snapshot.data ?? [];
          if (quotes.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Since it's a stream, just wait a short time to simulate refresh
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              itemCount: quotes.length + 1,
              itemBuilder: (context, index) {
                if (index == quotes.length) return const SizedBox(height: 24);
                final q = quotes[index];
                return QuoteCard(
                  quote: q,
                  isFavorite: true,
                  onFavorite: () async {
                    await service.removeFavorite(
                      user.uid,
                      q.id.isNotEmpty ? q.id : q.content.hashCode.toString(),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from favorites')),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
