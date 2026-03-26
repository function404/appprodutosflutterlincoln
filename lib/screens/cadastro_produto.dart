import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/produto.dart';

class CadastroProdutoScreen extends StatefulWidget {
  final Produto? produtoExistente;

  const CadastroProdutoScreen({super.key, this.produtoExistente});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeCtrl;
  late TextEditingController _precoCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imgCtrl;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.produtoExistente?.nome ?? '');
    _precoCtrl = TextEditingController(text: widget.produtoExistente?.preco.toString() ?? '');
    _descCtrl = TextEditingController(text: widget.produtoExistente?.descricao ?? '');
    _imgCtrl = TextEditingController(text: widget.produtoExistente?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _precoCtrl.dispose();
    _descCtrl.dispose();
    _imgCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: widget.produtoExistente?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeCtrl.text,
        preco: double.tryParse(_precoCtrl.text.replaceAll(',', '.')) ?? 0.0,
        descricao: _descCtrl.text,
        imageUrl: _imgCtrl.text,
      );
      
      Navigator.pop(context, produto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.produtoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome do Produto', border: OutlineInputBorder()),
                validator: (valor) => valor == null || valor.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$)', 
                  border: OutlineInputBorder()
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                
                validator: (valor) => valor == null || valor.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição (Opcional)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imgCtrl,
                decoration: const InputDecoration(labelText: 'URL da Imagem (Opcional)', border: OutlineInputBorder()),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Produto'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}