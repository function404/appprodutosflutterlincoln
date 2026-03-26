import 'package:flutter/material.dart';
import '../models/produto.dart';

class ListaProdutosScreen extends StatefulWidget {
  final bool modoNoturno;
  final VoidCallback aoAlternarTema;

  const ListaProdutosScreen({
    super.key,
    required this.modoNoturno,
    required this.aoAlternarTema,
  });

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  final List<Produto> _produtos = [];

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _mostrarAlertaFlutuante(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _abrirCadastro() async {
    final novoProduto = await Navigator.pushNamed(context, '/cadastro');
    if (novoProduto != null && novoProduto is Produto) {
      setState(() {
        _produtos.add(novoProduto);
      });
      _mostrarAlertaFlutuante('Produto criado com sucesso!', Colors.blue);
    }
  }

  Future<void> _abrirDetalhes(Produto produto) async {
    final resultado = await Navigator.pushNamed(context, '/detalhes', arguments: produto);

    if (resultado == 'deletar') {
      setState(() {
        _produtos.removeWhere((p) => p.id == produto.id);
      });
      _mostrarAlertaFlutuante('Produto removido!', Colors.orange);
    } else if (resultado is Produto) {
      setState(() {
        final index = _produtos.indexWhere((p) => p.id == resultado.id);
        if (index != -1) _produtos[index] = resultado;
      });
      _mostrarAlertaFlutuante('Produto atualizado!', Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.modoNoturno ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.aoAlternarTema,
          ),
        ],
      ),
      body: _produtos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum produto cadastrado.\nToque no + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _produtos.length,
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 80), 
              itemBuilder: (context, index) {
                final produto = _produtos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    leading: Hero(
                      tag: 'img-${produto.id}',
                      child: CircleAvatar(
                        backgroundColor: widget.modoNoturno ? Colors.orange : Colors.orange[100],
                        backgroundImage: produto.imageUrl.isNotEmpty ? NetworkImage(produto.imageUrl) : null,
                        child: produto.imageUrl.isEmpty 
                            ? const Icon(Icons.shopping_bag, color: Colors.orange)
                            : null,
                      ),
                    ),
                    title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_formatarPreco(produto.preco), style: const TextStyle(color: Colors.green)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _abrirDetalhes(produto),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}