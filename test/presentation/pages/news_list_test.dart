import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should call onFetchMore when scrolled near bottom', (
    tester,
  ) async {
    int called = 0;

    Widget makeList({required int itemCount}) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: NotificationListener<ScrollNotification>(
              onNotification: (sn) {
                if (sn.depth != 0) return false;
                if (sn is ScrollUpdateNotification &&
                    sn.metrics.axis == Axis.vertical &&
                    sn.metrics.pixels >= sn.metrics.maxScrollExtent - 400) {
                  called++;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (_, i) => const SizedBox(height: 100),
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(makeList(itemCount: 50));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();
    expect(called, 0, reason: 'should NOT trigger far from bottom');

    await tester.drag(find.byType(ListView), const Offset(0, -2600));
    await tester.pump();
    expect(called, greaterThan(0), reason: 'should trigger near bottom');
  });
}
