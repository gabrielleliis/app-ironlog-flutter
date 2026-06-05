import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../models/transaction_model.dart';
import '../services/api_service.dart';
import '../viewmodels/transaction_viewmodel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final Future<List<Map<String, dynamic>>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = ApiService().getFinancialNews();
    Future.microtask(() =>
      ref.read(transactionProvider.notifier).loadTransactions(),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  String _tipo = 'entrada';

  @override
  void dispose() {
    _tituloController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _showNewsDetail(Map<String, dynamic> news) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notícia financeira'),
        content: Text(news['headline'] as String),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static const double _newsSectionHeight = 160;

  bool _isValidImageUrl(dynamic image) {
    return image is String && image.isNotEmpty && image.startsWith('http');
  }

  Widget _buildNewsFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.newspaper, color: Colors.white54, size: 40),
      ),
    );
  }

  Widget _buildNewsBackground(dynamic image) {
    if (_isValidImageUrl(image)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          image as String,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildNewsFallbackBackground(),
        ),
      );
    }
    return _buildNewsFallbackBackground();
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    final headline = item['headline'] as String;

    return GestureDetector(
      onTap: () => _showNewsDetail(item),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: double.infinity,
          height: _newsSectionHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildNewsBackground(item['image']),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  headline,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSkeleton() {
    return SizedBox(
      height: _newsSectionHeight,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsError(String message) {
    return SizedBox(
      height: _newsSectionHeight,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: TextStyle(color: Colors.red.shade400, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _newsFuture = ApiService().getFinancialNews();
                });
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildNewsSkeleton();
        }

        if (snapshot.hasError) {
          return _buildNewsError('Não foi possível carregar as notícias.');
        }

        final news = snapshot.data ?? [];
        if (news.isEmpty) {
          return const SizedBox(
            height: _newsSectionHeight,
            child: Center(
              child: Text(
                'Nenhuma notícia disponível no momento.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: _newsSectionHeight,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
          ),
          items: news
              .map((item) => _buildNewsCard(item))
              .toList(),
        );
      },
    );
  }

  void _showAddTransactionModal() {
    // Limpa os campos quando o modal abrir
    _formKey.currentState?.reset();
    _tituloController.clear();
    _valorController.clear();
    _tipo = 'entrada';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Adicionar Transação', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o título' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Informe o valor';
                    final valor = double.tryParse(value.replaceAll(',', '.'));
                    if (valor == null || valor <= 0) return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'entrada',
                      child: Text('Entrada'),
                    ),
                    DropdownMenuItem(
                      value: 'saida',
                      child: Text('Saída'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tipo = value ?? 'entrada';
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final titulo = _tituloController.text.trim();
                        final valor = double.parse(
                            _valorController.text.replaceAll(',', '.'));
                        final transaction = TransactionModel(
                          titulo: titulo,
                          valor: valor,
                          data: DateTime.now(),
                          tipo: _tipo,
                        );
                        await ref
                            .read(transactionProvider.notifier)
                            .addTransaction(transaction);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final saldoTotal = ref.read(transactionProvider.notifier).saldoTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Total',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${saldoTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: saldoTotal >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          _buildNewsSection(),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação cadastrada.'))
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: t.tipo == 'entrada'
                                ? Colors.green[200]
                                : Colors.red[200],
                            child: Icon(
                              t.tipo == 'entrada' ? Icons.arrow_downward : Icons.arrow_upward,
                              color: t.tipo == 'entrada' ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(t.titulo),
                          subtitle: Text(
                            t.tipo == 'entrada' ? 'Entrada' : 'Saída',
                            style: TextStyle(
                                color: t.tipo == 'entrada' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'R\$ ${t.valor.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: t.tipo == 'entrada' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () async {
                                  await ref
                                      .read(transactionProvider.notifier)
                                      .deleteTransaction(t.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}