import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/app.dart';
import 'package:medlink/features/auth/presentation/screens/welcome_screen.dart';

void main() {
  testWidgets('app opens on the welcome screen', (tester) async {
    await tester.pumpWidget(const MedLinkApp());
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
