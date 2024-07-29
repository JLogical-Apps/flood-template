import 'package:flood_core/flood_core.dart';
import 'package:template_core/features/user/user_entity.dart';

class Todo extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField).required().hidden();

  static const completedField = 'completed';
  late final completedProperty = field<bool>(name: completedField).withFallback(() => false).hidden();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    ownerProperty,
    completedProperty,
    creationTime(),
  ];
}
