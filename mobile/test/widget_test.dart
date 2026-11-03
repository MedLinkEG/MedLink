import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/app.dart';
import 'package:medlink/features/home/presentation/home_page.dart';

void main() {
  testWidgets('app shows the home page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MedLinkApp()));
    expect(find.byType(HomePage), findsOneWidget);
  });
}
