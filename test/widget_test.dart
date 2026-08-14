import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:github_explorer/main.dart';

void main() {
  testWidgets('App boots successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GithubExplorerApp()),
    );

    expect(find.text('GitHub Explorer'), findsOneWidget);
  });
}
