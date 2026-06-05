import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_model.dart';
import '../viewmodels/transaction_viewmodel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
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