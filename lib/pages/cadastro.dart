import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Formulário de Cadastro',
            ),
          ),
        ),
        body: Padding(
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
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          maxLengthEnforced: true,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            labelStyle: TextStyle(),
                            hintText: 'Digite o nome completo',
                            hintStyle: TextStyle(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Nome não pode estar vazio.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
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
                            labelStyle: TextStyle(),
                            hintText: 'Digite o CPF',
                            hintStyle: TextStyle(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
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
                                return 'CPF não pode estar vazio!';
                                break;
                              default:
                                return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
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
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'E-mail não pode estar vazio.';
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'CEP não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FlatButton.icon(
                              label: Text('Buscar CEP'),
                              icon: Icon(Icons.search),
                              onPressed: () {},
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Endereço não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Número não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Bairro não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Cidade não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'UF não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 3,
                              child: TextFormField(
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
                                onChanged: (value) {
                                  print(value);
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'País não pode estar vazio.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                    },
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
