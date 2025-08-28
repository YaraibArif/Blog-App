import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuotesService {
  final String baseUrl = "https://dummyjson.com";

  Future<List<Quote>> fetchQuotes({int limit = 20, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/quotes?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List quotesJson = data['quotes'];
      return quotesJson.map((q) => Quote.fromJson(q)).toList();
    } else {
      throw Exception("Failed to load quotes");
    }
  }

  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse('$baseUrl/quotes/random'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Quote.fromJson(data);
    } else {
      throw Exception("Failed to load random quote");
    }
  }
}
