import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _Shell extends StatelessWidget {
  const _Shell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(body: child);
}

class _ListStub extends StatelessWidget {
  const _ListStub();
  @override
  Widget build(BuildContext context) => const SizedBox(key: Key('list'));
}

class _FavStub extends StatelessWidget {
  const _FavStub();
  @override
  Widget build(BuildContext context) => const SizedBox(key: Key('favorites'));
}

class _DetailsStub extends StatelessWidget {
  const _DetailsStub();
  @override
  Widget build(BuildContext context) => const SizedBox(key: Key('details'));
}

class _DummyArticle {
  const _DummyArticle();
}

GoRouter _makeTestRouter() => GoRouter(
  routes: [
    ShellRoute(
      builder: (_, __, child) => _Shell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'list',
          pageBuilder: (_, __) => const NoTransitionPage(child: _ListStub()),
          routes: [
            GoRoute(
              path: 'details',
              name: 'details',
              redirect: (context, state) =>
                  state.extra is _DummyArticle ? null : '/',
              builder: (_, state) => const _DetailsStub(),
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder: (_, __) => const _FavStub(),
        ),
      ],
    ),
  ],
);

void main() {
  testWidgets('should show list page at root', (tester) async {
    final router = _makeTestRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('list')), findsOneWidget);
  });

  testWidgets('should navigate to favorites', (tester) async {
    final router = _makeTestRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/favorites');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('favorites')), findsOneWidget);
  });

  testWidgets('should redirect to root when details opened without extra', (
    tester,
  ) async {
    final router = _makeTestRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/details');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('list')), findsOneWidget);
  });

  testWidgets('should open details when extra is provided', (tester) async {
    final router = _makeTestRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/details', extra: const _DummyArticle());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('details')), findsOneWidget);
  });
}
