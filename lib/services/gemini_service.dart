import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class GeminiService {
  static const String _apiKey = 'AIzaSyAYlZrHC2F4YzFToZrHcSv5QTTCaxFYSfQ';

  
  static const List<String> _modelsToTry = [
    'gemini-flash-latest',
    'gemini-2.0-flash',
    'gemini-2.5-flash',
    'gemini-pro-latest',
    'gemini-1.5-flash', 
  ];

  Future<Map<String, dynamic>> generateStory({
    required String level,
    required String category,
  }) async {
    final prompt =
        '''
Write a short story (180-220 words) for an English learner ($level level, category: $category). 

Return ONLY a JSON object:
{
  "title": "...",
  "sentences": [{"en": "...", "tr": "..."}],
  "dict": {"word": "translation"},
  "highlighted_words": ["word1", "word2"]
}

CRITICAL: 
1. The "dict" object MUST contain EVERY unique word in the story (100% coverage).
2. The "highlighted_words" list should contain only 5-8 most important or difficult words to highlight in the UI.
''';

    Object? lastError;

    for (final modelName in _modelsToTry) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: _apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );

        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text;

        if (text == null || text.isEmpty) continue;

        
        var cleanJson = text.trim();
        if (cleanJson.contains('```json')) {
          cleanJson = cleanJson.split('```json')[1].split('```')[0].trim();
        } else if (cleanJson.contains('```')) {
          cleanJson = cleanJson.split('```')[1].split('```')[0].trim();
        }

        return jsonDecode(cleanJson);
      } catch (e) {
        lastError = e;
        continue;
      }
    }

    throw Exception(
      'Hikaye oluşturulurken hata oluştu. Lütfen API ayarlarınızı kontrol edin.\n\nDetay: $lastError',
    );
  }
}
