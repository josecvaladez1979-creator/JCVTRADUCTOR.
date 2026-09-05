import 'package:dio/dio.dart';
import 'dart:typed_data';

class TranslationService {
  final Dio _dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 30), receiveTimeout: Duration(seconds: 60)));
  final String baseUrl = 'http://TU_IP:8000';

  Future<String> translateText(String text, String targetLang) async {
    final res = await _dio.post('$baseUrl:8003/translate', data: {'text': text, 'tgt_lang': targetLang});
    return res.data['translated_text'];
  }

  Future<Uint8List> translateVoice(Uint8List audioBytes, String targetLang) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(audioBytes, filename: 'audio.wav'),
      'target_lang': targetLang,
    });
    final res = await _dio.post('$baseUrl:8004/voice-to-voice', data: form, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(res.data);
  }
}
