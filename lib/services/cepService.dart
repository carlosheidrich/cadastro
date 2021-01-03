import 'package:dio/dio.dart';
import '../entities/endereco.dart';

var dio = Dio(BaseOptions(baseUrl: 'https://viacep.com.br/ws/'));

class CepService {
  Future<Endereco> buscaCep(String cep) async {
    try {
      var resp = await dio.get('$cep/json/');
      if (resp.statusCode == 200) {
        print(resp.data);
        var end = Endereco.fromJson(resp.data);
        return end;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.message != 'Http status error [404]') {
        print('Ocorreu um erro: ${e.message}');
      }
      return null;
    }
  }
}
