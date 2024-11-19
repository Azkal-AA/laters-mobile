import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latres/models/contentModel.dart';

class ApiService {
  static Future<List<ContentModel>> fetchData(String type) async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/$type/'));
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody)['results'] as List;
      return data.map((item) => ContentModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load $type');
    }
  }
}
