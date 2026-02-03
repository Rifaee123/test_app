import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';

void main() {
  testWidgets('App loads login page', (WidgetTester tester) async {
    await tester.pumpWidget(const EduTrackApp());
    expect(find.text('Welcome to EduTrack'), findsOneWidget);
  });
}
