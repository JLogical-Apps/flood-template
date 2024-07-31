import 'package:flood_core/flood_core.dart';
import 'package:template_core/features/todo/todo_entity.dart';
import 'package:template_core/features/user/user_entity.dart';

class Todo extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField).required().hidden();

  static const completedField = 'completed';
  late final completedProperty = field<bool>(name: completedField).withFallback(() => false).hidden();

  static const assetsField = 'assets';
  late final assetsProperty = field<String>(name: assetsField)
      .asset(assetProvider: (context) => context.locate<TodoAssetProvider>())
      .list()
      .withDisplayName('Assets');

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    ownerProperty,
    completedProperty,
    assetsProperty,
    creationTime(),
  ];
}

class TodoAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  TodoAssetProvider(this.context);

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'todos/${context.entityId}/assets')
      .fromRepository<TodoEntity>(context);
}
