import 'package:anonymous_send_wa/view/send_message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap() => const MaterialApp(
      home: Scaffold(
        body: SendMessageBox(width: 400, height: 600),
      ),
    );

void main() {
  testWidgets('renders the message field and send button', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('send button is disabled until all fields are filled',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });
}
