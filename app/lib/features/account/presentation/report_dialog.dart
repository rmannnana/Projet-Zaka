import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/account_requests_repository.dart';

extension ReportReasonLabel on ReportReason {
  String label(AppLocalizations l10n) => switch (this) {
    ReportReason.fraud => l10n.reportFraud,
    ReportReason.wrongInfo => l10n.reportWrongInfo,
    ReportReason.unavailable => l10n.reportUnavailable,
    ReportReason.inappropriate => l10n.reportInappropriate,
    ReportReason.duplicate => l10n.reportDuplicate,
    ReportReason.other => l10n.reportOther,
  };
}

/// Ouvre le formulaire de signalement d'une annonce ou d'un compte.
/// Utilisé sur les fiches hôtel, bien et programme (phases 3 et 4).
Future<void> showReportDialog(
  BuildContext context,
  WidgetRef ref, {
  required ReportTarget target,
  required String targetId,
}) async {
  final l10n = AppLocalizations.of(context);
  final uid = ref.read(authStateProvider).value?.uid;
  if (uid == null) {
    context.push('/connexion');
    return;
  }
  final messenger = ScaffoldMessenger.of(context);
  final details = TextEditingController();
  ReportReason? reason;

  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.reportTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioGroup<ReportReason>(
                groupValue: reason,
                onChanged: (v) => setState(() => reason = v),
                child: Column(
                  children: [
                    for (final r in ReportReason.values)
                      RadioListTile<ReportReason>(
                        value: r,
                        title: Text(r.label(l10n)),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
              TextField(
                controller: details,
                maxLines: 3,
                maxLength: 1000,
                decoration: InputDecoration(labelText: l10n.reportDetails),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: reason == null ? null : () => Navigator.pop(context, true),
            child: Text(l10n.reportSend),
          ),
        ],
      ),
    ),
  );
  final text = details.text;
  details.dispose();
  if (ok != true || reason == null) return;

  try {
    await ref.read(accountRequestsRepositoryProvider).report(
      reporterUid: uid,
      target: target,
      targetId: targetId,
      reason: reason!,
      details: text,
    );
    messenger.showSnackBar(SnackBar(content: Text(l10n.reportSent)));
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.genericError)));
  }
}
