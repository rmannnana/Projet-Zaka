import 'package:url_launcher/url_launcher.dart';

/// Appel téléphonique.
Future<void> callPhone(String phone) => launchUrl(Uri(scheme: 'tel', path: phone.replaceAll(' ', '')));

/// Discussion WhatsApp (très utilisé dans la zone UEMOA).
Future<void> openWhatsApp(String phone, {String text = ''}) => launchUrl(
  Uri.parse('https://wa.me/${phone.replaceAll(RegExp(r'[^0-9]'), '')}?text=${Uri.encodeComponent(text)}'),
  mode: LaunchMode.externalApplication,
);

/// Itinéraire vers une adresse (Google Maps, ou l'application de cartes du téléphone).
Future<void> openMap(String address) => launchUrl(
  Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}'),
  mode: LaunchMode.externalApplication,
);

/// Lien absolu (back-office) ou externe.
Future<void> openExternal(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
