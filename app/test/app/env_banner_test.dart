import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaka/app/app.dart';
import 'package:zaka/app/flavor.dart';

/// Par défaut, le bandeau « DEV » s'affiche. L'APK à partager se compile avec
/// `--dart-define=ENV_MARKS=false` : relancer ce test avec la même option vérifie qu'il disparaît.
void main() {
  const envMarks = bool.fromEnvironment('ENV_MARKS', defaultValue: true);

  // Sans le bandeau de debug de MaterialApp, qui est lui aussi un Banner.
  Widget app(Flavor flavor) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EnvBanner(flavor: flavor, child: const SizedBox()),
  );

  testWidgets('bandeau DEV, sauf dans l\'APK à partager', (tester) async {
    await tester.pumpWidget(app(Flavor.dev));
    expect(find.byType(Banner), envMarks ? findsOneWidget : findsNothing);
  });

  testWidgets('jamais de bandeau en production', (tester) async {
    await tester.pumpWidget(app(Flavor.prod));
    expect(find.byType(Banner), findsNothing);
  });
}
