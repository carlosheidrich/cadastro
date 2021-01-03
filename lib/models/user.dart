class User {
  int id;
  String name;
  String document;
  String email;
  int age;
  bool active;
  String cep;
  String endereco;
  String numero;
  String bairro;
  String cidade;
  String uf;
  String pais;

  User(
      {this.id,
      this.name,
      this.document,
      this.email,
      this.age,
      this.active = false,
      this.cep,
      this.endereco,
      this.numero,
      this.bairro,
      this.cidade,
      this.uf,
      this.pais});

  Map<String, dynamic> toDB() {
    var userMap = {
      'id': this.id,
      'name': this.name,
      'document': this.document,
      'email': this.email,
      'age': this.age,
      'active': this.active ? 1 : 0,
      'cep': this.cep,
      'endereco': this.endereco,
      'numero': this.numero,
      'bairro': this.bairro,
      'cidade': this.cidade,
      'uf': this.uf,
      'pais': this.pais
    };
    return userMap;
  }

  factory User.fromDB(Map<String, dynamic> user) {
    return User(
        id: user['id'] as int,
        name: user['name'],
        document: user['document'],
        email: user['email'],
        age: user['age'] as int,
        active: ((user['active'] as int) == 1),
        cep: user['cep'],
        endereco: user['endereco'],
        numero: user['numero'],
        bairro: user['bairro'],
        cidade: user['cidade'],
        uf: user['uf'],
        pais: user['pais']);
  }
}