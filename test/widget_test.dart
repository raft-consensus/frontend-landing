import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_landing/main.dart';

/// ¿Qué hace?: Prueba automatizada de widgets para verificar la inicialización de la pantalla principal.
/// ¿De dónde recibe datos?: Consume MyApp envuelto en un ProviderScope.
/// ¿Dónde se conecta?: Ejecutado por la acción `flutter test` en el pipeline CI/CD de GitHub Actions.
void main() {
  testWidgets('landing screen shows the expected content', (tester) async {
    // Inicializa el árbol de widgets con el ProviderScope de Riverpod
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Ejecuta el primer frame de renderizado estático
    await tester.pump();

    // Valida que los botones principales "Comenzar gratis" existan en la pantalla
    expect(find.text('Comenzar gratis'), findsWidgets);
  });
}
