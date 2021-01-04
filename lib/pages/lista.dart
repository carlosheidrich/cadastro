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
  List<User> users;
  var repository = UserRepository(DBSQLite());
  Future<List<User>> getUsers;

  @override
  void initState() {
    super.initState();
    getUsers = repository.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
      ),
      body: FutureBuilder(
        future: getUsers,
        builder: (_, AsyncSnapshot<List<User>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          users = snapshot.data;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              var user = users[index];
              return Dismissible(
                key: ValueKey(user.id),
                background: Container(
                  color: Colors.red,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Excluir',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  print('onDismissed');
                  Scaffold.of(_).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Usuário excluído!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                confirmDismiss: (direction) async {
                  print('confirmDismiss');
                  var confirmou = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    child: AlertDialog(
                      title: Text(
                        'Confirma a exclusão do usuário ${user.name}?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            'Sim',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            'Não',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ],
                    ),
                  );
                  if (confirmou) {
                    var deleted = await repository.deleteUser(user.id);
                    if (deleted) {
                      users.removeAt(index);
                      return true;
                    }
                  }

                  return false;
                },
                child: ListTile(
                  leading: Hero(
                    tag: user.id.toString(),
                    child: CircleAvatar(
                      backgroundImage: user.image != null
                          ? FileImage(user.image)
                          : AssetImage('assets/user02.jpg'),
                    ),
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
                  trailing: Icon(
                    user.active ? Icons.check_circle : Icons.highlight_off,
                    color: user.active ? Colors.green : Colors.red,
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
                ),
              );
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
