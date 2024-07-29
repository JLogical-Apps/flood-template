import 'package:flood_core/flood_core.dart';
import 'todo.dart';
import 'todo_entity.dart';

class TodoRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TodoEntity, Todo>(
    TodoEntity.new,
    Todo.new,
    entityTypeName: 'TodoEntity',
    valueObjectTypeName: 'Todo',
  ).adapting('todo');
}