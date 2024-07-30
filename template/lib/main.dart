import 'dart:async';

import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:template/firebase_options.dart';
import 'package:template/presentation/pages_pond_component.dart';
import 'package:template/presentation/style.dart';
import 'package:template_core/features/todo/todo.dart';
import 'package:template_core/features/todo/todo_entity.dart';
import 'package:template_core/features/user/user.dart';
import 'package:template_core/features/user/user_entity.dart';
import 'package:template_core/pond.dart';

// Whether to set up test data in the test suite.
const shouldAddTestData = true;

Future<void> main(List<String> args) async {
  await PondApp.run(
    appPondContextGetter: buildAppPondContext,
    loadingPage: StyledLoadingPage(),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.twoXl('Not Found!'),
      ),
    ),
  );
}

Future<AppPondContext> buildAppPondContext() async {
  final corePondContext = await getCorePondContext(
    initialCoreComponents: (context) => [
      FirebaseCoreComponent(app: DefaultFirebaseOptions.currentPlatform),
    ],
    repositoryImplementations: (context) => [
      FirebaseCloudRepositoryImplementation(),
    ],
    authServiceImplementations: (context) => [
      FirebaseAuthServiceImplementation(),
    ],
    environmentConfig: EnvironmentConfig.static.flutterAssets(),
    loggerService: (corePondContext) => corePondContext.environment.isOnline
        ? LoggerService.static.console.withFileLogHistory(corePondContext.fileSystem.tempDirectory / 'logs')
        : LoggerService.static.console,
  );

  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(FloodAppComponent(style: style));
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    if (shouldAddTestData) {
      await _setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(PagesAppPondComponent());

  return appPondContext;
}

Future<void> _setupTesting(CorePondContext corePondContext) async {
  final account = await corePondContext.authCoreComponent
      .signup(AuthCredentials.email(email: 'test@test.com', password: 'password'));

  await corePondContext.dropCoreComponent.updateEntity(
    UserEntity()
      ..id = account.accountId
      ..set(User()
        ..nameProperty.set('Test')
        ..emailProperty.set('test@test.com')),
  );

  // Create some test Todos
  final todoNames = ['Buy groceries', 'Finish project', 'Call mom', 'Go for a run', 'Read a book'];
  for (var i = 0; i < todoNames.length; i++) {
    await corePondContext.dropCoreComponent.updateEntity(TodoEntity()
      ..set(
        Todo()
          ..nameProperty.set(todoNames[i])
          ..ownerProperty.set(account.accountId)
          ..completedProperty.set(i == 0), // Only the first Todo should be completed
      ));
  }
}
