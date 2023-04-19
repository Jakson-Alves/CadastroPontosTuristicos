import '../database/database_provider.dart';
import '../model/tarefa.dart';

class TarefaDao {
  final databaseProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async {
    final database = await databaseProvider.database;
    final valores = tarefa.toMap();
    if (tarefa.id == null) {
      tarefa.id = await database.insert(Tarefa.NOME_TABELA, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        Tarefa.NOME_TABELA,
        valores,
        where: '${Tarefa.CAMPO_ID} = ?',
        whereArgs: [tarefa.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      Tarefa.NOME_TABELA,
      where: '${Tarefa.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<Tarefa>> listar({
    String filtro = '',
    String campoOrdenacao = Tarefa.CAMPO_ID,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Tarefa.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final database = await databaseProvider.database;
    final resultado = await database.query(
      Tarefa.NOME_TABELA,
      columns: [
        Tarefa.CAMPO_ID,
        Tarefa.CAMPO_DESCRICAO,
        Tarefa.CAMPO_DIFERENCIAL,
        Tarefa.CAMPO_DTATUAL,
        Tarefa.campoFinalizada
      ],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}