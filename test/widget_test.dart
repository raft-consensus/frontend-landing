import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_landing/main.dart';

void main() {
  testWidgets('landing screen shows the expected content', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SITIO EN DESARROLLO'), findsOneWidget);
    expect(find.text('Acceso Administrador'), findsOneWidget);
    expect(find.byIcon(Icons.construction_rounded), findsOneWidget);
  });
}
