import 'package:intl/intl.dart';

class Tarefa{
  static const NOME_TABELA = 'tarefa';
  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAL = 'diferencial';
  static const CAMPO_DTATUAL = 'dtAtual';
  static const campoFinalizada = 'finalizada';

  int? id;
  String descricao;
  String diferencial;
  DateTime? dtAtual;
  bool finalizada;

  Tarefa({
    this.id,
    required this.descricao,
    required this.diferencial,
    this.dtAtual,
    this.finalizada = false,
  });

  String get dtAtualFormatado{
    if (dtAtual == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(dtAtual!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DIFERENCIAL: diferencial,
    CAMPO_DTATUAL:
    dtAtual == null ? null : DateFormat("yyyy-MM-dd").format(dtAtual!),
    campoFinalizada: finalizada ? 1 : 0,
  };

  factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    diferencial: map[CAMPO_DIFERENCIAL] is String ? map[CAMPO_DIFERENCIAL] : '',
    dtAtual: map[CAMPO_DTATUAL] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_DTATUAL])
        : null,
    finalizada: map[campoFinalizada] == 1,
  );
}