import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_landing/main.dart';

void main() {
  testWidgets('landing screen shows the expected content', (tester) async {
    // MyApp depende de Riverpod (ConsumerWidget), así que necesita un
    // ProviderScope como ancestro, igual que en main.dart.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Se usa pump() en lugar de pumpAndSettle() porque la landing page
    // dispara una llamada de red real (platformMetricsProvider) al
    // construirse; pumpAndSettle() esperaría indefinidamente esa future
    // en el entorno de CI, donde no hay acceso al backend.
    await tester.pump();

    // Se valida contenido estático del hero, que se renderiza en el
    // primer frame sin depender de datos remotos.
    expect(find.text('Crear base de datos gratis'), findsOneWidget);
    expect(find.text('Cómo funciona'), findsOneWidget);
  });
}
