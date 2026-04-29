import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fun_lab/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('大学生学习监督 App 可以正常启动', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const StudySupervisorApp());
    await tester.pumpAndSettle();

    expect(find.text('大学生学习监督'), findsOneWidget);
    expect(find.text('监督台'), findsOneWidget);
    expect(find.text('专注'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });
}