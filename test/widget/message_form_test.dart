import 'dart:async';

import 'package:anonymous_send_wa/theme/app_theme.dart';
import 'package:anonymous_send_wa/view/message_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapForm({required LauncherCallback launcher}) => MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: Scaffold(
        body: MessageForm(launcher: launcher),
      ),
    );

ElevatedButton _button(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.byType(ElevatedButton));

/// The phone field is an [InternationalPhoneNumberInput] which renders the
/// first editable text; the message field is the last one in the tree.
Finder _messageField() => find.byType(EditableText).last;

Future<void> _fillValidForm(WidgetTester tester) async {
  await tester.enterText(find.byType(EditableText).first, '5551234567');
  await tester.enterText(_messageField(), 'Hello there');
  await tester.pumpAndSettle();
}

void main() {
  group('MessageForm', () {
    testWidgets('renders the message field and send button', (tester) async {
      await tester.pumpWidget(_wrapForm(launcher: (_) async => true));
      await tester.pumpAndSettle();

      expect(find.text('Send Message'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
    });

    testWidgets('send button is disabled until all fields are filled',
        (tester) async {
      await tester.pumpWidget(_wrapForm(launcher: (_) async => true));
      await tester.pumpAndSettle();

      expect(_button(tester).onPressed, isNull);
    });

    testWidgets('send button enables once phone and message are filled',
        (tester) async {
      await tester.pumpWidget(_wrapForm(launcher: (_) async => true));
      await tester.pumpAndSettle();

      await _fillValidForm(tester);

      expect(_button(tester).onPressed, isNotNull);
    });

    testWidgets('invokes launcher and shows success feedback on success',
        (tester) async {
      var calls = 0;
      Uri? launchedUrl;
      await tester.pumpWidget(
        _wrapForm(launcher: (url) async {
          calls++;
          launchedUrl = url;
          return true;
        }),
      );
      await tester.pumpAndSettle();
      await _fillValidForm(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(calls, 1);
      expect(launchedUrl?.host, 'wa.me');
      expect(launchedUrl?.queryParameters['text'], 'Hello there');
      expect(find.text('Opening WhatsApp...'), findsOneWidget);
      // Message field is cleared on success.
      expect(tester.widget<EditableText>(_messageField()).controller.text, '');
    });

    testWidgets('shows error feedback when launcher returns false',
        (tester) async {
      await tester.pumpWidget(_wrapForm(launcher: (_) async => false));
      await tester.pumpAndSettle();
      await _fillValidForm(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Could not open WhatsApp'), findsOneWidget);
    });

    testWidgets('disables the button while a send is in flight',
        (tester) async {
      final completer = Completer<bool>();
      await tester.pumpWidget(_wrapForm(launcher: (_) => completer.future));
      await tester.pumpAndSettle();
      await _fillValidForm(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(_button(tester).onPressed, isNull);

      completer.complete(true);
      await tester.pumpAndSettle();
    });
  });
}
