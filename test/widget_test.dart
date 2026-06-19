// Smoke test dasar: pastikan app bisa di-build tanpa crash.

import 'package:flutter_test/flutter_test.dart';

import 'package:project_tracker_app/main.dart';

void main() {
  testWidgets('App ter-build tanpa error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProjectTrackerApp());

    // Pastikan judul app muncul.
    expect(find.text('Project Tracker'), findsOneWidget);
  });
}
