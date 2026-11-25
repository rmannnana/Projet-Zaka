import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/notifications_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/admin_shell.dart';
import '../features/admin/presentation/audit_screen.dart';
import '../features/admin/presentation/catalogs_screen.dart';
import '../features/admin/presentation/moderation_screens.dart';
import '../features/admin/presentation/org_review_screens.dart';
import '../features/admin/presentation/requests_screens.dart';
import '../features/admin/presentation/team_screen.dart';
import '../features/admin/presentation/billing_admin_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/verify_phone_screen.dart';
import '../features/billing/presentation/checkout_screen.dart';
import '../features/billing/presentation/org_commissions_screen.dart';
import '../features/billing/presentation/subscription_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/hotels/presentation/hotel_detail_screen.dart';
import '../features/hotels/presentation/hotel_search_screen.dart';
import '../features/listings/domain/listing.dart';
import '../features/listings/presentation/favorites_and_legal.dart';
import '../features/pro/presentation/hotel_editor_screen.dart';
import '../features/pro/presentation/pro_inbox_screens.dart';
import '../features/pro/presentation/pro_listings_screen.dart';
import '../features/pro/presentation/realestate_editors.dart';
import '../features/realestate/presentation/property_detail_screen.dart';
import '../features/realestate/presentation/property_search_screen.dart';
import '../features/requests/presentation/client_requests_screens.dart';
import '../features/home/presentation/home_shell.dart';
import '../features/organizations/presentation/create_org_screen.dart';
import '../features/organizations/presentation/members_screen.dart';
import '../features/organizations/presentation/org_screen.dart';
import '../features/organizations/presentation/pro_home_screen.dart';
import '../features/organizations/presentation/verification_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Routes de l'app publique (clients et espaces pros).
final publicRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    // Espaces pros et vérification du numéro : connexion obligatoire.
    redirect: (context, state) {
      final path = state.matchedLocation;
      const private = ['/pro', '/demandes', '/reservations', '/contacts', '/paiement', '/favoris'];
      final needsAuth = private.any(path.startsWith) ||
          path == '/compte/telephone' ||
          path == '/compte/notifications';
      final auth = ref.read(authStateProvider);
      if (!needsAuth || auth.isLoading || auth.value != null) return null;
      return '/connexion?retour=${Uri.encodeComponent(state.uri.toString())}';
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/hotels', builder: (_, state) => hotelSearchFromUri(state.uri)),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/immobilier', builder: (_, state) => propertySearchFromUri(state.uri)),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/demandes', builder: (_, _) => const MyRequestsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/compte',
              builder: (_, _) => const AccountScreen(),
              routes: [
                GoRoute(
                  path: 'notifications',
                  parentNavigatorKey: _rootKey,
                  builder: (_, _) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'telephone',
                  parentNavigatorKey: _rootKey,
                  builder: (_, state) =>
                      VerifyPhoneScreen(redirectTo: state.uri.queryParameters['retour']),
                ),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/hotel/:hotelId',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          DateTime? day(String key) => DateTime.tryParse(state.uri.queryParameters[key] ?? '');
          return HotelDetailScreen(
            hotelId: state.pathParameters['hotelId']!,
            checkIn: day('arrivee'),
            checkOut: day('depart'),
            guests: int.tryParse(state.uri.queryParameters['voyageurs'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: '/bien/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => PropertyDetailScreen(propertyId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/programme/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ProjectDetailScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/reservations/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/contacts/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LeadDetailScreen(leadId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/paiement/:paymentId',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => CheckoutScreen(
          paymentId: state.pathParameters['paymentId']!,
          backLocation: state.uri.queryParameters['retour'] ?? '/demandes',
        ),
      ),
      GoRoute(path: '/favoris', parentNavigatorKey: _rootKey, builder: (_, _) => const FavoritesScreen()),
      GoRoute(
        path: '/cgu',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const LegalScreen(document: LegalDocument.terms),
      ),
      GoRoute(
        path: '/confidentialite',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const LegalScreen(document: LegalDocument.privacy),
      ),
      GoRoute(
        path: '/connexion',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => SignInScreen(redirectTo: state.uri.queryParameters['retour']),
      ),
      GoRoute(
        path: '/pro',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ProHomeScreen(),
        routes: [
          GoRoute(
            path: 'nouveau',
            builder: (_, state) =>
                CreateOrgScreen(type: orgTypeFromParam(state.uri.queryParameters['type'])),
          ),
          GoRoute(
            path: ':orgId',
            builder: (_, state) => OrgScreen(orgId: state.pathParameters['orgId']!),
            routes: [
              GoRoute(
                path: 'dossier',
                builder: (_, state) => VerificationScreen(orgId: state.pathParameters['orgId']!),
              ),
              GoRoute(
                path: 'profil',
                builder: (_, state) => EditOrgScreen(orgId: state.pathParameters['orgId']!),
              ),
              GoRoute(
                path: 'membres',
                builder: (_, state) => MembersScreen(orgId: state.pathParameters['orgId']!),
              ),
              GoRoute(
                path: 'abonnement',
                builder: (_, state) => SubscriptionScreen(orgId: state.pathParameters['orgId']!),
              ),
              GoRoute(
                path: 'paiement/:paymentId',
                builder: (_, state) => CheckoutScreen(
                  orgId: state.pathParameters['orgId']!,
                  paymentId: state.pathParameters['paymentId']!,
                ),
              ),
              GoRoute(
                path: 'commissions',
                builder: (_, state) => OrgCommissionsScreen(orgId: state.pathParameters['orgId']!),
              ),
              GoRoute(
                path: 'annonces',
                builder: (_, state) => ProListingsScreen(orgId: state.pathParameters['orgId']!),
                routes: [
                  GoRoute(
                    path: ':kind/:id',
                    builder: (_, state) {
                      final orgId = state.pathParameters['orgId']!;
                      final id = state.pathParameters['id']!;
                      return switch (ListingKind.fromSlug(state.pathParameters['kind']!)) {
                        ListingKind.hotel => HotelEditorScreen(orgId: orgId, hotelId: id),
                        ListingKind.property => PropertyEditorScreen(orgId: orgId, propertyId: id),
                        ListingKind.project => ProjectEditorScreen(orgId: orgId, projectId: id),
                      };
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'reservations',
                builder: (_, state) => ProBookingsScreen(orgId: state.pathParameters['orgId']!),
                routes: [
                  GoRoute(
                    path: ':bookingId',
                    builder: (_, state) => ProBookingDetailScreen(
                      orgId: state.pathParameters['orgId']!,
                      bookingId: state.pathParameters['bookingId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'contacts',
                builder: (_, state) => ProLeadsScreen(orgId: state.pathParameters['orgId']!),
                routes: [
                  GoRoute(
                    path: ':leadId',
                    builder: (_, state) => ProLeadDetailScreen(
                      orgId: state.pathParameters['orgId']!,
                      leadId: state.pathParameters['leadId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

/// Routes du back-office : réservé aux rôles `admin` et `moderator`.
final adminRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(staffRoleProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final here = state.matchedLocation;
      String? goTo(String path) => here == path ? null : path;

      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return goTo('/chargement');
      if (auth.value == null) return goTo('/connexion');

      final role = ref.read(staffRoleProvider);
      if (role.isLoading) return goTo('/chargement');
      final isStaff = role.value == 'admin' || role.value == 'moderator';
      if (!isStaff) return goTo('/interdit');

      final adminOnly = adminDestinations.where((d) => d.adminOnly).map((d) => d.path);
      if (role.value != 'admin' && adminOnly.any(here.startsWith)) return '/';

      return const {'/connexion', '/interdit', '/chargement'}.contains(here) ? '/' : null;
    },
    routes: [
      ShellRoute(
        builder: (_, state, child) => AdminShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const AdminDashboardScreen()),
          GoRoute(
            path: '/comptes',
            builder: (_, _) => const OrgReviewListScreen(),
            routes: [
              GoRoute(
                path: ':orgId',
                builder: (_, state) => OrgReviewScreen(orgId: state.pathParameters['orgId']!),
              ),
            ],
          ),
          GoRoute(path: '/annonces', builder: (_, _) => const ListingReviewScreen()),
          GoRoute(path: '/signalements', builder: (_, _) => const ReportsScreen()),
          GoRoute(path: '/litiges', builder: (_, _) => const DisputesScreen()),
          GoRoute(path: '/suppressions', builder: (_, _) => const DeletionRequestsScreen()),
          GoRoute(path: '/equipe', builder: (_, _) => const TeamScreen()),
          GoRoute(path: '/catalogues', builder: (_, _) => const CatalogsScreen()),
          GoRoute(path: '/facturation', builder: (_, _) => const BillingAdminScreen()),
          GoRoute(path: '/journal', builder: (_, _) => const AuditScreen()),
        ],
      ),
      GoRoute(path: '/connexion', builder: (_, _) => const SignInScreen(redirectTo: '/')),
      GoRoute(path: '/interdit', builder: (_, _) => const AdminForbiddenScreen()),
      GoRoute(
        path: '/chargement',
        builder: (_, _) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
