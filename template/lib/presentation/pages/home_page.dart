import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:template/presentation/pages/login_page.dart';
import 'package:template/presentation/pages/todo_details_page.dart';
import 'package:template/utils/route_utils.dart';
import 'package:template_core/features/todo/todo.dart';
import 'package:template_core/features/todo/todo_entity.dart';
import 'package:template_core/features/user/user.dart';
import 'package:template_core/features/user/user_entity.dart';

class HomeRoute with IsRoute<HomeRoute> {
  static const onlyCompletedField = 'only_completed';
  late final onlyCompletedProperty = field<bool>(name: onlyCompletedField).withFallback(() => false);

  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  List<RouteProperty> get queryProperties => [onlyCompletedProperty];

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().onlyIfAccountExists();

  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    final todosModel = useQuery(getTodosQuery(loggedInUserId, route.onlyCompletedProperty.value).all());
    final userModel = useEntityOrNull<UserEntity>(loggedInUserId);

    return StyledPage(
      titleText: 'Todos',
      actionWidgets: [
        ModelBuilder(
          model: userModel,
          builder: (UserEntity? userEntity) {
            return StyledContainer(
              width: 40,
              height: 40,
              shape: CircleBorder(),
              child: userEntity?.value.profilePictureProperty.value != null
                  ? StyledAssetProperty(
                      assetProperty: userEntity!.value.profilePictureProperty.value!,
                      fit: BoxFit.cover,
                    )
                  : StyledIcon(Icons.person),
              onPressed: () async {
                await context.showStyledDialog(StyledDialog.actionList(
                  context: context,
                  actions: [
                    ActionItem(
                      titleText: 'Upload Profile Picture',
                      descriptionText: 'Upload a profile picture to your account.',
                      color: Colors.blue,
                      iconData: Icons.image,
                      onPerform: (_) async {
                        final asset = await AssetPicker.select(context, AllowedFileTypes.image);
                        if (asset != null) {
                          await userEntity!.value.profilePictureProperty.uploadAsset(context.assetCoreComponent, asset);
                        }
                      },
                    ),
                    if (userEntity?.value.profilePictureProperty.value != null)
                      ActionItem(
                        titleText: 'Remove Profile Picture',
                        descriptionText: 'Remove your profile picture.',
                        color: Colors.red,
                        iconData: Icons.image_not_supported,
                        onPerform: (_) async {
                          await userEntity!.value.profilePictureProperty.deleteAsset(context.assetCoreComponent);
                        },
                      ),
                    ActionItem(
                      titleText: 'Edit Profile Picture',
                      descriptionText: 'Edit your profile picture.',
                      color: Colors.orange,
                      iconData: Icons.face,
                      onPerform: (_) async {
                        await context.showStyledDialog(StyledPortDialog(
                          titleText: 'Edit Profile Picture',
                          port: userEntity!.value.asPort(context.corePondContext, only: [User.profilePictureField]),
                          onAccept: (User user) async {
                            await context.dropCoreComponent.updateEntity(userEntity..set(user));
                          },
                        ));
                      },
                    ),
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
                ));
              },
            );
          },
        )
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
                          onPressed: () => context.push(TodoDetailsRoute()..todoIdProperty.set(todoEntity.id!)),
                          actions: ActionItem.static.entityCrudActions(context,
                              entity: todoEntity,
                              duplicator: (Todo todo) => todo..nameProperty.update((name) => '$name - Copy')),
                          children: [
                            if (todoEntity.value.assetsProperty.value.isNotEmpty)
                              StyledList.row.withScrollbar(
                                children: todoEntity.value.assetsProperty.value
                                    .map((asset) => StyledAssetProperty(assetProperty: asset, height: 80))
                                    .toList(),
                              ),
                          ],
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Query<TodoEntity> getTodosQuery(String? loggedInUserId, bool onlyCompleted) {
    Query<TodoEntity> query = Query.from<TodoEntity>()
        .where(Todo.ownerField)
        .isEqualTo(loggedInUserId)
        .orderByAscending(CreationTimeProperty.field);

    if (onlyCompleted) {
      query = query.where(Todo.completedField).isEqualTo(true);
    }

    return query;
  }
}
