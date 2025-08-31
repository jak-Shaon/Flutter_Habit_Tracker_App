import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch quotes from API or fallback
  Future<List<Quote>> fetchQuotes({int limit = 10}) async {
    try {
      final uri = Uri.parse('https://api.quotable.io/quotes?limit=$limit');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final results = (json.decode(res.body)['results'] as List)
            .map((e) => Quote.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (results.isNotEmpty) return results;
      }
    } on SocketException {
      print("No internet connection, using fallback quotes.");
    } catch (e) {
      print("Error fetching quotes: $e");
    }

    // Fallback quotes (local static list)
    return [
      Quote(id: '1', content: 'Stay positive, work hard, make it happen.', author: 'Unknown'),
      Quote(id: '2', content: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt'),
      Quote(id: '3', content: 'Do something today that your future self will thank you for.', author: 'Unknown'),
      Quote(id: '4', content: 'Success is not final, failure is not fatal: It is the courage to continue that counts.', author: 'Winston Churchill'),
      Quote(id: '5', content: 'Don’t watch the clock; do what it does. Keep going.', author: 'Sam Levenson'),
      Quote(id: '6', content: 'Great things never come from comfort zones.', author: 'Unknown'),
      Quote(id: '7', content: 'Opportunities don’t happen, you create them.', author: 'Chris Grosser'),
      Quote(id: '8', content: 'Push yourself, because no one else is going to do it for you.', author: 'Unknown'),
      Quote(id: '9', content: 'Dream big and dare to fail.', author: 'Norman Vaughan'),
      Quote(id: '10', content: 'Hard work beats talent when talent doesn’t work hard.', author: 'Tim Notke'),
      Quote(id: '11', content: 'Don’t stop when you’re tired. Stop when you’re done.', author: 'Unknown'),
      Quote(id: '12', content: 'The secret of getting ahead is getting started.', author: 'Mark Twain'),
      Quote(id: '13', content: 'Your limitation—it’s only your imagination.', author: 'Unknown')
    ];
  }

  CollectionReference<Map<String, dynamic>> favQuotesRef(String uid) =>
      _db.collection('users').doc(uid).collection('favorites').doc('quotes').collection('items');

  Future<void> addFavorite(String uid, Quote q) async {
    await favQuotesRef(uid).doc(q.id.isNotEmpty ? q.id : q.content.hashCode.toString()).set(q.toMap());
  }

  Future<void> removeFavorite(String uid, String quoteId) async {
    await favQuotesRef(uid).doc(quoteId).delete();
  }

  Stream<List<Quote>> watchFavorites(String uid) {
    return favQuotesRef(uid).snapshots().map(
          (snap) => snap.docs.map((d) => Quote.fromMap({'id': d.id, ...d.data()})).toList(),
    );
  }
}
