import 'package:cadastro/infra/db_sqlite.dart';
import 'package:cadastro/models/user.dart';
import 'package:cadastro/pages/cadastro.dart';
import 'package:cadastro/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class ListUsersPage extends StatefulWidget {
  @override
  _ListUsersPageState createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  var users = <User>[
    /*User(
      name: 'Carlos Alexandre Heidrich',
      document: '010.440.810-31',
      age: 33,
      email: 'karlusheidrich@gmail.com',
      cep: '93.900-000',
      endereco: 'Alameda dos Ipês',
      numero: '149',
      bairro: 'Jardim Panorâmico',
      cidade: 'Ivoti',
      uf: 'RS',
      pais: 'Brasil',
      active: true,
    ),
    User(
      name: 'Samuel Eduardo Heidrich',
      document: '051.490.520-06',
      age: 4,
      email: 'karlusheidrich@gmail.com',
      cep: '93.900-000',
      endereco: 'Alameda dos Ipês',
      numero: '149',
      bairro: 'Jardim Panorâmico',
      cidade: 'Ivoti',
      uf: 'RS',
      pais: 'Brasil',
      active: false,
    ),*/
  ];

  var repository = UserRepository(DBSQLite());

  @override
  void initState() {
    super.initState();

    repository.getUsers().then((value) {
      setState(() {
        users = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) {
          var user = users[index];
          return ListTile(
            leading: Icon(
              user.active ? Icons.check_circle : Icons.highlight_off,
              color: user.active ? Colors.green : Colors.red,
            ),
            title: Text(
              '${user.name}, ${user.age} anos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CPF: ${user.document}'),
                Text('E-Mail: ${user.email}'),
              ],
            ),
            isThreeLine: true,
            onTap: () async {
              var userUpdated = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Cadastro(
                    user: user,
                  ),
                ),
              );
              if (userUpdated != null) {
                setState(() {
                  user = userUpdated;
                });
              }
            },
            onLongPress: () async {
              var deleted = await repository.deleteUser(user.id);
              if (deleted) {
                setState(() {
                  users.removeAt(index);
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var user = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => Cadastro()),
          );
          if (user != null) {
            setState(() {
              users.add(user);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
