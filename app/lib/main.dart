import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/flavor.dart';

/// App publique : clients, hôtels, agences, promoteurs, particuliers.
/// Android et web. Exemple :
///   flutter run --flavor dev --dart-define=FLAVOR=dev
Future<void> main() => bootstrap(const ZakaApp(target: AppTarget.public));
