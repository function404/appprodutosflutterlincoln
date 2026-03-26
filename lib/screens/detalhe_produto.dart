import 'package:flutter/material.dart';
import '../models/produto.dart';

class DetalheProdutoScreen extends StatelessWidget {
  final Produto produto;

  const DetalheProdutoScreen({super.key, required this.produto});

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _editar(BuildContext context) async {
    final produtoEditado = await Navigator.pushNamed(
      context, 
      '/cadastro', 
      arguments: produto,
    );

    if (!context.mounted) return;

    if (produtoEditado != null) {
      Navigator.pop(context, produtoEditado); 
    }
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content: Text('Tem certeza que deseja excluir "${produto.nome}"? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(contextoDialogo); 
                Navigator.pop(context, 'deletar'); 
              },
              child: const Text('Sim, excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), 
            onPressed: () => _editar(context),
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'img-${produto.id}',
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.white,
                  image: produto.imageUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(produto.imageUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: produto.imageUrl.isEmpty 
                    ? const Icon(Icons.shopping_bag, size: 100, color: Colors.grey) 
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatarPreco(produto.preco),
                    style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    produto.descricao.isNotEmpty ? produto.descricao : 'Nenhuma descrição informada.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Excluir Produto', style: TextStyle(fontSize: 18)),
                      onPressed: () => _confirmarExclusao(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}