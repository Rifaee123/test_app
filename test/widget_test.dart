import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    final sl = GetIt.instance;
    await sl.reset();
    await initDI();
  });

  testWidgets('App loads login page', (WidgetTester tester) async {
    await tester.pumpWidget(const EduTrackApp());
    await tester.pumpAndSettle();
    expect(find.text('Welcome to EduTrack'), findsOneWidget);
  });
}
