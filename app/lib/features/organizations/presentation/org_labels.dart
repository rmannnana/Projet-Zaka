import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';

extension OrgTypeLabel on OrgType {
  String label(AppLocalizations l10n) => switch (this) {
    OrgType.hotel => l10n.orgTypeHotel,
    OrgType.agency => l10n.orgTypeAgency,
    OrgType.developer => l10n.orgTypeDeveloper,
    OrgType.individualOwner => l10n.orgTypeIndividual,
  };

  IconData get icon => switch (this) {
    OrgType.hotel => Icons.hotel,
    OrgType.agency => Icons.real_estate_agent_outlined,
    OrgType.developer => Icons.domain,
    OrgType.individualOwner => Icons.person_outline,
  };

  /// Teinte de la tuile d'icône du type.
  Tone get tone => switch (this) {
    OrgType.hotel => Tone.peach,
    OrgType.agency => Tone.sky,
    OrgType.developer => Tone.lavender,
    OrgType.individualOwner => Tone.sage,
  };
}

extension VerificationStatusLabel on VerificationStatus {
  String label(AppLocalizations l10n) => switch (this) {
    VerificationStatus.draft => l10n.statusDraft,
    VerificationStatus.pending => l10n.statusPending,
    VerificationStatus.verified => l10n.statusVerified,
    VerificationStatus.rejected => l10n.statusRejected,
    VerificationStatus.suspended => l10n.statusSuspended,
  };

  Color color(ColorScheme scheme) => switch (this) {
    VerificationStatus.verified => ZakaColors.success,
    VerificationStatus.pending => ZakaColors.warning,
    VerificationStatus.rejected || VerificationStatus.suspended => scheme.error,
    VerificationStatus.draft => scheme.outline,
  };
}

extension DocumentKindLabel on DocumentKind {
  String label(AppLocalizations l10n) => switch (this) {
    DocumentKind.ifu => l10n.documentIfu,
    DocumentKind.rccm => l10n.documentRccm,
    DocumentKind.proofOfAddress => l10n.documentProofOfAddress,
  };
}

/// Statut de vérification en pastille colorée.
class VerificationStatusChip extends StatelessWidget {
  const VerificationStatusChip(this.status, {super.key});

  final VerificationStatus status;

  @override
  Widget build(BuildContext context) =>
      StatusPill(status.label(AppLocalizations.of(context)), status.color(Theme.of(context).colorScheme));
}
