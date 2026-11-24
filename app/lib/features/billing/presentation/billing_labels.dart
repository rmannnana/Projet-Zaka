import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/billing.dart';

final billingDate = DateFormat.yMMMMd('fr');

extension SubscriptionPlanLabels on SubscriptionPlan {
  /// « 15 000 FCFA par mois », ou « Gratuit ».
  String priceLabel(AppLocalizations l10n) {
    if (price.amount == 0) return l10n.billingFree;
    final amount = price.format();
    return period == PlanPeriod.year ? l10n.billingPricePerYear(amount) : l10n.billingPricePerMonth(amount);
  }

  /// Avantages du plan, une ligne chacun.
  List<String> featureLabels(AppLocalizations l10n) => [
    features.maxListings == null
        ? l10n.billingUnlimitedListings
        : l10n.billingMaxListings(features.maxListings!),
    l10n.billingFeaturedListings(features.featuredListings),
    if (features.advancedStats) l10n.billingAdvancedStats,
  ];
}

extension PaymentStatusLabel on PaymentStatus {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentStatus.pending => l10n.paymentStatusPending,
    PaymentStatus.succeeded => l10n.paymentStatusSucceeded,
    PaymentStatus.failed => l10n.paymentStatusFailed,
    PaymentStatus.cancelled => l10n.paymentStatusCancelled,
  };

  Color color(ColorScheme scheme) => switch (this) {
    PaymentStatus.succeeded => Colors.green.shade700,
    PaymentStatus.pending => Colors.orange.shade800,
    PaymentStatus.failed => scheme.error,
    PaymentStatus.cancelled => scheme.outline,
  };
}

extension CommissionStatusLabel on CommissionStatus {
  String label(AppLocalizations l10n) => switch (this) {
    CommissionStatus.due => l10n.commissionStatusDue,
    CommissionStatus.invoiced => l10n.commissionStatusInvoiced,
    CommissionStatus.paid => l10n.commissionStatusPaid,
    CommissionStatus.waived => l10n.commissionStatusWaived,
  };

  Color color(ColorScheme scheme) => switch (this) {
    CommissionStatus.due => Colors.orange.shade800,
    CommissionStatus.invoiced => scheme.primary,
    CommissionStatus.paid => Colors.green.shade700,
    CommissionStatus.waived => scheme.outline,
  };
}

/// Pastille de statut colorée.
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, this.color, {super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
    visualDensity: VisualDensity.compact,
    side: BorderSide(color: color),
    label: Text(label, style: TextStyle(color: color)),
  );
}
