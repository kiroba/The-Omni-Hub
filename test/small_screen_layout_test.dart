import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omniverse_superapp/omni_fit.dart';

// A 320x568 dp phone (old/small Android) with a long AppBar action list
// must lay out without overflow; extra icons move into a "More" menu.
void main() {
  testWidgets('AppBar actions fit a 320x568 screen', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    var tapped = '';
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('The Omniverse', maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: fitAppBarActions(context, [
              for (final n in ['Wallet', 'Report a bug', 'Check for updates', 'Settings', 'Info'])
                IconButton(icon: const Icon(Icons.star), tooltip: n, onPressed: () => tapped = n),
            ]),
          ),
          body: const SizedBox.shrink(),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Info'));
    await tester.pumpAndSettle();
    expect(tapped, 'Info');
  });
}
