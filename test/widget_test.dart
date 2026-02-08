import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twine/app/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TwineApp()));
    await tester.pumpAndSettle();

    // Welcome screen should be visible
    expect(find.text('Welcome'), findsWidgets);
  });
}
