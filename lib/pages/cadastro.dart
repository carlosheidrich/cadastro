import 'package:brasil_fields/brasil_fields.dart';
import 'package:cadastro/infra/db_sqlite.dart';
import 'package:cadastro/models/user.dart';
import 'package:cadastro/repositories/user_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import '../controllers/cepController.dart';

class Cadastro extends StatefulWidget {
  final User user;

  const Cadastro({this.user});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final String initialValue = '';
  User user;
  var _cepController = TextEditingController();
  var _enderecoController = TextEditingController();
  var _bairroController = TextEditingController();
  var _cidadeController = TextEditingController();
  var _ufController = TextEditingController();
  var _paisController = TextEditingController();

  @override
  void initState() {
    super.initState();

    user = widget?.user ?? User();
    _cepController.text = user.cep;
    _enderecoController.text = user.endereco;
    _bairroController.text = user.bairro;
    _cidadeController.text = user.cidade;
    _ufController.text = user.uf;
    _paisController.text = user.pais;
  }

  void saveUser() async {
    if (!_formKey.currentState.validate()) {
      showSnackBar(
        message: 'Formulário inválido!',
        color: Colors.red,
      );
      return;
    }

    _formKey.currentState.save();

    var repository = UserRepository(DBSQLite());

    if (user.id == null) {
      user.id = await repository.saveUser(user);
    } else {
      var updated = await repository.updateUser(user);
      if (!updated) {
        showSnackBar(
          message: 'Usuário não atualizado!',
          color: Colors.red,
        );
        return;
      }
    }

    Navigator.of(context).pop(user);
  }

  void showSnackBar({String message, Color color}) {
    _scafoldKey.currentState.hideCurrentSnackBar();
    _scafoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text(
          '${user.name == null ? 'Novo' : 'Editar'} Usuário',
          textAlign: TextAlign.center,
        ),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: user?.name,
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            hintText: 'Digite o nome completo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSaved: (value) => user.name = value,
                          validator: (value) {
                            return value.isEmpty ? 'Campo obrigatório' : null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: user?.document,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CpfInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'CPF',
                                  hintText: 'Digite o CPF',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onSaved: (value) => user.document = value,
                                validator: (value) {
                                  var status = CnpjCpfBase.cpfValidate(value);
                                  switch (status) {
                                    case EDocumentStatus.DIGIT:
                                      return 'O dígito do CPF está errado!';
                                      break;
                                    case EDocumentStatus.FORMAT:
                                      return 'O formato do CPF está errado!';
                                      break;
                                    case EDocumentStatus.EMPTY:
                                      return 'Campo obrigatório';
                                      break;
                                    default:
                                      return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: (user?.age ?? '').toString(),
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Idade',
                                  hintText: 'Digite a Idade',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                //controller: cpfController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Campo obrigatório';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) =>
                                    user.age = int.tryParse(value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: user.email,
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            hintText: 'Digite o E-Mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSaved: (value) => user.email = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo obrigatório';
                            } else {
                              if (EmailValidator.validate(value)) {
                                return null;
                              } else {
                                return 'E-Mail inválido!';
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                //initialValue: user?.cep,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CepInputFormatter(ponto: true),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'CEP',
                                  hintText: 'Digite o CEP',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _cepController,
                                onSaved: (value) => user.cep = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FlatButton.icon(
                              label: Text('Buscar CEP'),
                              icon: Icon(Icons.search),
                              height: 60,
                              onPressed: () async {
                                var controller = CepController();
                                var end = await controller
                                    .buscaCep(_cepController.text);

                                setState(() {
                                  _enderecoController.text =
                                      user.endereco = end.logradouro;
                                  _bairroController.text =
                                      user.bairro = end.bairro;
                                  _cidadeController.text =
                                      user.cidade = end.localidade;
                                  _ufController.text = user.uf = end.uf;
                                  _paisController.text =
                                      user.endereco = 'Brasil';
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: TextFormField(
                                //initialValue: user?.endereco,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Endereço',
                                  hintText: 'Digite o endereço',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _enderecoController,
                                onSaved: (value) => user.endereco = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue: user?.numero,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Número',
                                  hintText: 'Digite o número',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onSaved: (value) => user.numero = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextFormField(
                                //initialValue: user?.bairro,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Bairro',
                                  hintText: 'Digite o Bairro',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _bairroController,
                                onSaved: (value) => user.bairro = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                //initialValue: user?.cidade,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Cidade',
                                  hintText: 'Digite a cidade',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _cidadeController,
                                onSaved: (value) => user.cidade = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextFormField(
                                //initialValue: user?.uf,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'UF',
                                  hintText: 'Digite a UF',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _ufController,
                                onSaved: (value) => user.uf = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 3,
                              child: TextFormField(
                                //initialValue: user?.pais,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'País',
                                  hintText: 'Digite o país',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _paisController,
                                onSaved: (value) => user.pais = value,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Switch(
                                value: user?.active,
                                onChanged: (value) {
                                  setState(() {
                                    user.active = value;
                                  });
                                },
                              ),
                              Text(user.active ? 'Ativo' : 'Inativo'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlineButton(
                    child: Text(
                      'Salvar',
                    ),
                    textColor: Colors.red[900],
                    borderSide: BorderSide(
                      color: Colors.red[900],
                    ),
                    onPressed: saveUser,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
