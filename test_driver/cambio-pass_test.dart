import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tfg/pantallas/cambiarPass.dart';

void main() {
  Widget createWidgetForTesting({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  group('TFG App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
    testWidgets('Widget cambiar de contraseña cargado', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      Widget testWidget = createWidgetForTesting(child: CambiarPass());
      await tester.pumpWidget(testWidget);
      expect(find.text("Nueva contraseña"), findsOneWidget);
    });

    testWidgets('Cambiar de contraseña', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      Widget testWidget = createWidgetForTesting(child: CambiarPass());
      await tester.pumpWidget(testWidget);
      
      final passAntiguaField = find.byKey(Key('passActual'));
      final passNuevaField = find.byKey(Key('passNueva'));
      final passNuevaRepetidaField = find.byKey(Key('passNuevaRepetida'));
      await tester.enterText(passAntiguaField, "123456");
      await tester.enterText(passNuevaField, "654321");
      await tester.enterText(passNuevaRepetidaField, "654321");
      expect(find.text("123456"), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
