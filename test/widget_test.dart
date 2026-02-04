import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sl = GetIt.instance;
    await sl.reset();
    await initDI();
  });

  testWidgets('App loads login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduTrackApp());

    // Verify that LoginPage is shown (it has 'Student Login' button)
    expect(find.text('Login as Student'), findsOneWidget);
  });
}
