import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:template_core/features/todo/todo.dart';
import 'package:template_core/features/todo/todo_entity.dart';

class TodoDetailsRoute with IsRoute<TodoDetailsRoute> {
  late final todoIdProperty = field<String>(name: 'todoId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('todo').property(todoIdProperty);

  @override
  TodoDetailsRoute copy() => TodoDetailsRoute();
}

class TodoDetailsPage with IsAppPage<TodoDetailsRoute> {
  @override
  Widget onBuild(BuildContext context, TodoDetailsRoute route) {
    final todoModel = useEntity<TodoEntity>(route.todoIdProperty.value);

    return ModelBuilder.page(
      model: todoModel,
      builder: (TodoEntity todoEntity) {
        return StyledPage(
          titleText: 'Todo Details',
          body: StyledList.column.withScrollbar(
            children: [
              StyledText.xl(todoEntity.value.nameProperty.value),
              StyledCheckbox(
                value: todoEntity.value.completedProperty.value,
                labelText: 'Completed',
                onChanged: (value) {
                  context.dropCoreComponent.updateEntity(
                    todoEntity,
                    (Todo todo) => todo..completedProperty.set(value),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
