import 'package:flutter/material.dart';

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
    VerificationStatus.verified => Colors.green.shade700,
    VerificationStatus.pending => Colors.orange.shade800,
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

class VerificationStatusChip extends StatelessWidget {
  const VerificationStatusChip(this.status, {super.key});

  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(Theme.of(context).colorScheme);
    return Chip(
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      label: Text(status.label(AppLocalizations.of(context)), style: TextStyle(color: color)),
    );
  }
}
