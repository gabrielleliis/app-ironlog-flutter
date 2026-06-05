import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/db_helper.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  final DatabaseHelper dbHelper;

  AuthNotifier(this.dbHelper) : super(null);

  Future<bool> login(String email, String senha) async {
    final userMap = await dbHelper.getUser(email, senha);
    if (userMap != null) {
      state = UserModel.fromMap(userMap);
      return true;
    }
    return false;
  }

  Future<bool> register(String nome, String email, String senha) async {
    final user = UserModel(nome: nome, email: email, senha: senha);
    await dbHelper.insertUser(user.toMap());
    return await login(email, senha);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(DatabaseHelper());
});