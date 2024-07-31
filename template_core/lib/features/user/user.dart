import 'package:flood_core/flood_core.dart';
import 'package:template_core/features/user/user_entity.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').isNotBlank().isEmail();

  static const profilePictureField = 'profilePicture';
  late final profilePictureProperty = field<String>(name: profilePictureField)
      .asset(
        assetProvider: (context) => context.locate<UserProfilePictureAssetProvider>(),
        allowedFileTypes: AllowedFileTypes.image,
      )
      .withDisplayName('Profile Picture');

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    profilePictureProperty,
    creationTime(),
  ];
}

class UserProfilePictureAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  UserProfilePictureAssetProvider(this.context);

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'users/${context.entityId}/profilePicture')
      .fromRepository<UserEntity>(context);
}
