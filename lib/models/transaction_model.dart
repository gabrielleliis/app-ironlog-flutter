class TransactionModel {
  int? id;
  String titulo;
  double valor;
  DateTime data;
  String tipo; // 'entrada' ou 'saida'

  TransactionModel({
    this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'data': data.toIso8601String(),
      'tipo': tipo,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      valor: (map['valor'] as num).toDouble(),
      data: DateTime.parse(map['data'] as String),
      tipo: map['tipo'] as String,
    );
  }
}
