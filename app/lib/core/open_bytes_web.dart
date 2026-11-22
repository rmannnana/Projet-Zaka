import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<void> openBytes(Uint8List bytes, String contentType) async {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: contentType));
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  // Le lien local est libéré après une minute.
  Future.delayed(const Duration(minutes: 1), () => web.URL.revokeObjectURL(url));
}
