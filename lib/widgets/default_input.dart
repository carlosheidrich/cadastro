import 'package:brasil_fields/brasil_fields.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class DefaultInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isCPF;
  final bool isCEP;
  final bool isEmail;
  final bool isRequired;
  final String Function(String) validator;
  final void Function(String) onSaved;

  const DefaultInput(
      {Key key,
      this.label,
      this.hint = '',
      this.isCPF = false,
      this.isCEP = false,
      this.isEmail = false,
      this.isRequired = false,
      this.controller,
      this.validator,
      this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.send,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        isCPF ? CpfInputFormatter() : isCEP ? CepInputFormatter(): null,
      ],
      decoration: InputDecoration(
        labelText: this.label,
        hintText: this.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      controller: this.controller,
      onSaved: (value) => this.onSaved,
      validator: (value) {
        if (isCPF) {
          var status = CnpjCpfBase.cpfValidate(value);
          switch (status) {
            case EDocumentStatus.DIGIT:
              return 'O dígito do CPF está errado!';
              break;
            case EDocumentStatus.FORMAT:
              return 'O formato do CPF está errado!';
              break;
            case EDocumentStatus.EMPTY:
              return isRequired ? 'Campo obrigatório' : null;
              break;
            default:
              return null;
          }
        } else if (isEmail) {
          if (value.isEmpty) {
            return isRequired ? 'Campo obrigatório' : null;
          } else {
            if (EmailValidator.validate(value)) {
              return null;
            } else {
              return 'E-Mail inválido!';
            }
          }
        } else {
          if (value.isEmpty) {
            return isRequired ? 'Campo obrigatório' : null;
          }
        }
      },
    );
  }
}
