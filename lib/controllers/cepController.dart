import '../entities/endereco.dart';
import '../services/cepService.dart';

class CepController {
  CepController();

  Future<Endereco> buscaCep(String cep) async {
    var cepServ = CepService();

    cep = cep.replaceAll('.', '');
    cep = cep.replaceAll('-', '');

    var end = await cepServ.buscaCep(cep);

    return end;
  }
}
