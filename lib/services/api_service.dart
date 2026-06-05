import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> getFinancialNews() async {
    const String url =
        'https://finnhub.io/api/v1/news?category=general&token=d8hkff1r01qrn5ecj6p0d8hkff1r01qrn5ecj6pg';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.take(5).map<Map<String, dynamic>>((item) {
          return {
            'headline': item['headline'] ?? 'Sem título',
            'url': item['url'] ?? '',
            'image': item['image'] ?? '',
          };
        }).toList();
      }

      throw Exception('Resposta inválida da API de notícias.');
    } on DioException catch (e) {
      throw Exception('Erro ao buscar notícias financeiras: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao buscar notícias financeiras.');
    }
  }
}
