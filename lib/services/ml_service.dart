// nothing is implemented inside in this.
// 📁 ml_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MLService {
  static const String _baseUrl =
      'http://10.0.2.2:8000'; // Localhost for emulator

  Future<Map<String, dynamic>> analyzeCottonQuality(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/predict/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: 'cotton_quality.jpg',
        ),
      );

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseString);
      } else {
        final errorData = json.decode(responseString);
        throw Exception(errorData['error'] ?? 'Analysis failed');
      }
    } catch (e) {
      throw Exception('Failed to analyze image: ${e.toString()}');
    }
  }
}
