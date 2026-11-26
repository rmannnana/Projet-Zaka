import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';
import 'org_labels.dart';
import 'org_profile_form.dart';

/// Création d'un espace publieur : choix du type, puis profil public.
class CreateOrgScreen extends ConsumerWidget {
  const CreateOrgScreen({super.key, this.type});

  /// Type choisi (paramètre `type` de l'URL), ou null pour afficher le choix.
  final OrgType? type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final type = this.type;
    return Scaffold(
      appBar: AppBar(title: Text(type == null ? l10n.proCreate : type.label(l10n))),
      body: Readable(maxWidth: 640, child: type == null ? const _TypeChoice() : _ProfileStep(type: type)),
    );
  }
}

class _TypeChoice extends ConsumerWidget {
  const _TypeChoice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orgs = ref.watch(myOrganizationsProvider).value ?? const [];
    final hasIndividual = orgs.any((o) => o.type == OrgType.individualOwner);

    Widget option(OrgType type, String description) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: ToneIcon(type.icon, tone: type.tone, size: 48),
        title: Text(type.label(l10n), style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 2), child: Text(description)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          final phone = ref.read(authStateProvider).value?.phoneNumber;
          final target = '/pro/nouveau?type=${_typeParam(type)}';
          if (type == OrgType.individualOwner && phone == null) {
            context.push('/compte/telephone?retour=${Uri.encodeComponent(target)}');
          } else {
            context.replace(target);
          }
        },
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PageIntro(title: l10n.proTypeTitle, text: l10n.proTypeIntro),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(l10n.proChooseType, style: Theme.of(context).textTheme.titleSmall),
        ),
        if (!hasIndividual) option(OrgType.individualOwner, l10n.orgTypeIndividualHelp),
        option(OrgType.hotel, l10n.orgTypeHotelHelp),
        option(OrgType.agency, l10n.orgTypeAgencyHelp),
        option(OrgType.developer, l10n.orgTypeDeveloperHelp),
      ],
    );
  }
}

String _typeParam(OrgType type) => type == OrgType.individualOwner ? 'individual_owner' : type.name;

/// Lit le paramètre `type` de l'URL.
OrgType? orgTypeFromParam(String? value) => switch (value) {
  'individual_owner' => OrgType.individualOwner,
  'hotel' => OrgType.hotel,
  'agency' => OrgType.agency,
  'developer' => OrgType.developer,
  _ => null,
};

class _ProfileStep extends ConsumerWidget {
  const _ProfileStep({required this.type});

  final OrgType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;
    final isIndividual = type == OrgType.individualOwner;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NoticeCard(
          icon: type.icon,
          tone: type.tone,
          text: isIndividual ? l10n.proIndividualIntro : l10n.proBusinessIntro,
        ),
        const SizedBox(height: 20),
        OrgProfileForm(
          type: type,
          submitLabel: l10n.proCreateSubmit,
          initial: OrgProfileValues(
            name: isIndividual ? (profile?.displayName ?? user?.displayName ?? '') : '',
            description: '',
            contact: OrgContact(
              phone: user?.phoneNumber ?? '',
              email: user?.email,
              city: '',
              country: profile?.country ?? 'BF',
            ),
          ),
          onSubmit: (values) async {
            try {
              final orgId = await ref
                  .read(organizationRepositoryProvider)
                  .create(
                    NewOrganization(
                      type: type,
                      name: values.name,
                      description: values.description,
                      phone: values.contact.phone,
                      email: values.contact.email,
                      address: values.contact.address,
                      city: values.contact.city,
                      country: values.contact.country,
                    ),
                  );
              if (context.mounted) {
                context.pushReplacement(isIndividual ? '/pro/$orgId' : '/pro/$orgId/dossier');
              }
              return null;
            } catch (e) {
              return functionErrorMessage(e);
            }
          },
        ),
      ],
    );
  }
}
