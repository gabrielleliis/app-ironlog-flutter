class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  final List<Map<String, dynamic>> _users = [];
  final List<Map<String, dynamic>> _transactions = [];
  int _userIdCounter = 1;
  int _transactionIdCounter = 1;

  Future<int> insertUser(Map<String, dynamic> user) async {
    final id = _userIdCounter++;
    _users.add({...user, 'id': id});
    return id;
  }

  Future<Map<String, dynamic>?> getUser(String email, String senha) async {
    for (final user in _users) {
      if (user['email'] == email && user['senha'] == senha) {
        return user;
      }
    }
    return null;
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final id = _transactionIdCounter++;
    _transactions.add({...transaction, 'id': id});
    return id;
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    return List<Map<String, dynamic>>.from(_transactions);
  }

  Future<int> deleteTransaction(int id) async {
    _transactions.removeWhere((transaction) => transaction['id'] == id);
    return 1;
  }
}
