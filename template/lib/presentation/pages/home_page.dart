import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:template/presentation/pages/login_page.dart';
import 'package:template_core/features/todo/todo.dart';
import 'package:template_core/features/todo/todo_entity.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().withRedirect((context, route) async {
        final loggedInUserId = context.authCoreComponent.loggedInUserId;
        if (loggedInUserId == null) {
          return LoginRoute().routeData;
        }
        return null;
      });

  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    final todosModel = useQuery(Query.from<TodoEntity>()
        .where(Todo.ownerField)
        .isEqualTo(loggedInUserId)
        .orderByAscending(CreationTimeProperty.field)
        .all());

    return StyledPage(
      titleText: 'Todos',
      actions: [
        ActionItem(
          titleText: 'Log Out',
          descriptionText: 'Log out of your account',
          iconData: Icons.logout,
          color: Colors.red,
          onPerform: (context) async {
            await context.authCoreComponent.logout();
            context.warpTo(LoginRoute());
          },
        ),
      ],
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledButton.strong(
            labelText: 'Create Todo',
            onPressed: loggedInUserId == null
                ? null
                : () async {
                    await context.showStyledDialog(StyledPortDialog(
                      titleText: 'Create Todo',
                      port: (Todo()..ownerProperty.set(loggedInUserId)).asPort(context.corePondContext),
                      onAccept: (Todo todo) async {
                        await context.dropCoreComponent.updateEntity(TodoEntity()..set(todo));
                      },
                    ));
                  },
          ),
          ModelBuilder(
            model: todosModel,
            builder: (List<TodoEntity> todoEntities) {
              return StyledList.column(
                ifEmptyText: 'You have no Todos!',
                children: todoEntities
                    .map((todoEntity) => StyledCard(
                          titleText: todoEntity.value.nameProperty.value,
                          leading: StyledCheckbox(
                            value: todoEntity.value.completedProperty.value,
                            onChanged: (value) {
                              context.dropCoreComponent
                                  .updateEntity(todoEntity, (Todo todo) => todo..completedProperty.set(value));
                            },
                          ),
                          actions: ActionItem.static.entityCrudActions(context,
                              entity: todoEntity,
                              duplicator: (Todo todo) => todo..nameProperty.update((name) => '$name - Copy')),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
