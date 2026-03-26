class Produto {
  String id;
  String nome;
  double preco;
  String descricao;
  String imageUrl;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    this.descricao = '',
    this.imageUrl = '',
  });
}