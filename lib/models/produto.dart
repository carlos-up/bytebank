class Produto {
  String _id;
  String _nome;
  String _preco;

  Produto(this._id, this._nome, this._preco);

  Produto.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._preco = obj['preco'];
  }

  String get id => _id;
  String get nome => _nome;
  String get preco => _preco;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['preco'] = _preco;

    return map;
  }

  Produto.fromMap(Map<String, dynamic> map, String id) {
    //atribui id a this_id
    //somente se id nao for null
    //se id for null atribui ''
    this._id = id ?? '';
    this._nome = map['nome'];
    this._preco = map['preco'];
  }
}
