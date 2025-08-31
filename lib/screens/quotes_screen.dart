import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quote_model.dart';
import '../providers/auth_provider.dart';
import '../services/quotes_service.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final _service = QuotesService();
  List<Quote> _quotes = [];
  Set<String> _favoriteIds = {}; // Track favorited quote IDs
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _service.fetchQuotes(limit: 15);
      list.shuffle(Random());
      setState(() => _quotes = list);
    } catch (e) {
      print("Failed to load quotes: $e");
      setState(() => _quotes = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _listenFavorites(String uid) {
    _service.watchFavorites(uid).listen((favQuotes) {
      if (mounted) {
        setState(() {
          _favoriteIds = favQuotes.map((q) => q.id).toSet();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    _load();
    _listenFavorites(user.uid); // Start listening to favorite changes
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motivational Quotes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
            tooltip: "Favorites",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _quotes.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text("No quotes available.")),
          ],
        )
            : ListView.builder(
          itemCount: _quotes.length + 1,
          itemBuilder: (context, index) {
            if (index == _quotes.length) return const SizedBox(height: 24);
            final q = _quotes[index];
            final isFav = _favoriteIds.contains(q.id);
            return QuoteCard(
              quote: q,
              isFavorite: isFav,
              onFavorite: () async {
                if (isFav) {
                  await _service.removeFavorite(
                    user.uid,
                    q.id.isNotEmpty ? q.id : q.content.hashCode.toString(),
                  );
                } else {
                  await _service.addFavorite(user.uid, q);
                }
                // UI will update automatically via the Stream listener
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _load,
        child: const Icon(Icons.refresh),
        tooltip: "Refresh Quotes",
      ),
    );
  }
}
