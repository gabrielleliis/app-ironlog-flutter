import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../services/db_helper.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final DatabaseHelper dbHelper;

  TransactionNotifier(this.dbHelper) : super([]);

  Future<void> loadTransactions() async {
    final transactionMaps = await dbHelper.getTransactions();
    final transactions = transactionMaps
        .map((map) => TransactionModel.fromMap(map))
        .toList();
    state = transactions;
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await dbHelper.insertTransaction(transaction.toMap());
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await dbHelper.deleteTransaction(id);
    await loadTransactions();
  }

  double get saldoTotal {
    double saldo = 0.0;
    for (var t in state) {
      if (t.tipo == 'entrada') {
        saldo += t.valor;
      } else if (t.tipo == 'saida') {
        saldo -= t.valor;
      }
    }
    return saldo;
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
  (ref) => TransactionNotifier(DatabaseHelper()),
);
