import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/flavor.dart';

/// Back-office ZAKA (web uniquement). Exemple :
///   flutter run -d chrome -t lib/main_admin.dart --dart-define=FLAVOR=dev
Future<void> main() => bootstrap(const ZakaApp(target: AppTarget.admin));
