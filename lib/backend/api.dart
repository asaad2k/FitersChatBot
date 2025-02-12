import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update the base URL to point to the correct endpoint
  final String baseUrl = 'https://74b6-34-16-255-184.ngrok-free.app/ask';  // Updated

  Future<Map<String, dynamic>> getAnswer(String question) async {
    print('Question: $question');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Print the response body for easier debugging in case of failure
      print('Failed to get answer: ${response.body}');
      throw Exception('Failed to get answer: ${response.statusCode}');
    }
  }
}
