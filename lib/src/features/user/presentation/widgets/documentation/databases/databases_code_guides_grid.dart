// ==========================================
// Que hace: Cuadricula responsiva de 3 columnas con snippets funcionales de conexion en Flutter, Node.js, Python, C#, Java y Go.
// De donde trae datos: Coleccion de ejemplos verificados para conectar instancias de bases de datos Raft.
// Donde se conecta: Consumido dentro de DatabasesGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Cuadricula modular con las 6 guias de conexion a bases de datos en filas de 3 columnas
class DatabasesCodeGuidesGrid extends StatelessWidget {
  const DatabasesCodeGuidesGrid({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // 3 columnas en pantallas grandes, 2 en medianas y 1 en moviles
        final cols = width >= 1150 ? 3 : (width >= 720 ? 2 : 1);
        final cardWidth = (width - (cols - 1) * 16) / cols;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // 1. Flutter / Dart (PostgreSQL)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Flutter / Dart (postgres)',
                description: 'Integración mediante el driver oficial postgres con soporte asíncrono y SSL configurable.',
                snippet: "import 'package:postgres/postgres.dart';\n\nFuture<void> main() async {\n  final endpoint = Endpoint(\n    host: 'pg01.raftdb.dev',\n    database: 'mi_database',\n    username: 'usuario_raft',\n    password: 'password_seguro',\n    port: 5432,\n  );\n\n  final conn = await Connection.open(\n    endpoint,\n    settings: const ConnectionSettings(sslMode: SslMode.disable),\n  );\n\n  final result = await conn.execute('SELECT 1;');\n  print(result);\n  await conn.close();\n}",
                icon: Icons.flutter_dash_rounded,
                badgeText: 'Flutter / Dart',
                badgeColor: AppColors.dayAccent,
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 2. Node.js / TypeScript (pg)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Node.js (Client / pg)',
                description: 'Conexión estándar con el paquete pg o Prisma ORM en entornos Express / Fastify / NestJS.',
                snippet: "import { Client } from 'pg';\n\nconst client = new Client({\n  host: 'pg01.raftdb.dev',\n  port: 5432,\n  database: 'mi_database',\n  user: 'usuario_raft',\n  password: 'password_seguro',\n  ssl: false,\n});\n\nawait client.connect();\nconst res = await client.query('SELECT NOW();');\nconsole.log(res.rows[0]);\nawait client.end();",
                icon: Icons.code_rounded,
                badgeText: 'Node.js / TS',
                badgeColor: const Color(0xFF10B981),
                estimatedTime: '3 min',
                onMessage: onMessage,
              ),
            ),

            // 3. Python (psycopg2)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Python (psycopg2 / SQLAlchemy)',
                description: 'Conexión directa con cursor para scripts de automatización, Django o FastAPI.',
                snippet: 'import psycopg2\n\nconn = psycopg2.connect(\n    host="pg01.raftdb.dev",\n    port=5432,\n    dbname="mi_database",\n    user="usuario_raft",\n    password="password_seguro",\n    sslmode="disable"\n)\n\ncursor = conn.cursor()\ncursor.execute("SELECT version();")\nprint(cursor.fetchone())\ncursor.close()\nconn.close()',
                icon: Icons.terminal_rounded,
                badgeText: 'Python',
                badgeColor: const Color(0xFFF59E0B),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 4. C# / .NET (Npgsql)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'C# / .NET (Npgsql)',
                description: 'Uso de NpgsqlDataSource de alto rendimiento para Entity Framework Core y APIs .NET 8/9.',
                snippet: 'using Npgsql;\n\nvar connString = "Host=pg01.raftdb.dev;Port=5432;Database=mi_database;Username=usuario_raft;Password=password_seguro;SSL Mode=Disable";\n\nawait using var dataSource = NpgsqlDataSource.Create(connString);\nawait using var cmd = dataSource.CreateCommand("SELECT version();");\nvar version = await cmd.ExecuteScalarAsync();\n\nConsole.WriteLine(\$"Conectado: {version}");',
                icon: Icons.integration_instructions_rounded,
                badgeText: 'C# / .NET',
                badgeColor: const Color(0xFF8B5CF6),
                estimatedTime: '3 min',
                onMessage: onMessage,
              ),
            ),

            // 5. Java (JDBC / Spring Boot)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Java (JDBC / DriverManager)',
                description: 'Conexión universal con el driver oficial de PostgreSQL compatible con Spring Data JPA.',
                snippet: 'import java.sql.Connection;\nimport java.sql.DriverManager;\nimport java.sql.ResultSet;\nimport java.sql.Statement;\n\npublic class App {\n    public static void main(String[] args) throws Exception {\n        String url = "jdbc:postgresql://pg01.raftdb.dev:5432/mi_database?sslmode=disable";\n        Connection conn = DriverManager.getConnection(url, "usuario_raft", "password_seguro");\n\n        Statement stmt = conn.createStatement();\n        ResultSet rs = stmt.executeQuery("SELECT version();");\n        if (rs.next()) {\n            System.out.println("Conectado: " + rs.getString(1));\n        }\n        conn.close();\n    }\n}',
                icon: Icons.coffee_rounded,
                badgeText: 'Java / Spring',
                badgeColor: const Color(0xFFEF4444),
                estimatedTime: '3 min',
                onMessage: onMessage,
              ),
            ),

            // 6. Golang (pgx/v5)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Golang (pgx/v5)',
                description: 'Driver nativo optimizado con soporte para context y pooling de conexiones.',
                snippet: 'package main\n\nimport (\n  "context"\n  "fmt"\n  "github.com/jackc/pgx/v5"\n)\n\nfunc main() {\n  url := "postgres://usuario_raft:password_seguro@pg01.raftdb.dev:5432/mi_database?sslmode=disable"\n  conn, err := pgx.Connect(context.Background(), url)\n  if err != nil {\n    panic(err)\n  }\n  defer conn.Close(context.Background())\n\n  var version string\n  conn.QueryRow(context.Background(), "SELECT version()").Scan(&version)\n  fmt.Println("Conectado:", version)\n}',
                icon: Icons.memory_rounded,
                badgeText: 'Golang',
                badgeColor: const Color(0xFF06B6D4),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),
          ],
        );
      },
    );
  }
}
