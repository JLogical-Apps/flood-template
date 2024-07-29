import 'package:flood_core/flood_core.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').isNotBlank().isEmail();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    creationTime(),
  ];
}
