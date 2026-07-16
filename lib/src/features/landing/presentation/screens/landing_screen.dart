import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background pendiente
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // algun logo o algo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 64,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 40,),
              // titulo
              const Text(
                'SITIO EN DESARROLLO',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              // Descripcion
              const Text(
                'Estamos trabajando para ofrecerte los mejores servicios de bases de datos. ¡La espera valdrá la pena!!!... Sigue pendiente',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  height: 1.5
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              // boton de prueba / futuro login
              ElevatedButton.icon(onPressed: () {

              }, 
              label: Text('Acceso Administrador'),
              icon: const Icon(Icons.login_rounded),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15)
                )
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
