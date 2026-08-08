
# Database-Centric Architecture

## Plataforma de Hosting DB & Servicios para Desarrolladores

El objetivo de este proyecto es diseñar e implementar un sistema de información robusto y seguro que actúe como un **proveedor de servicios de bases de datos gratuitas (y herramientas de prueba)** para estudiantes y desarrolladores.

## Requirimentos originales

Los usuario podran crear cierto limite de bases de datos en los distintos motores de bases de datos. Se proponen tres opciones:
1. Dos bases de datos por cada motor con un limite de 10mb de almacenamiento por cada una.
2. 5 bases de datos a libre eleccion con maximo 20mb de almacenamiento cada una
3. 80mb de almacenamiento limite por usuario y eleccion de motores y bases de datos libre.

## Nuevos requerimientos.
Debido a que somos varios grupos haciendo lo mismo se opto por una fusion de todos (8 o 9 vps, cada uno con una vps de 4gb de ram y 50gb de almacenamiento) los recursos y añadir tres nuevos servicios.

### servicios
1. MySQL
2. Postgres
3. SQLserver
4. MongoDB
5. DNS (es posible que esto lo administren todas las vps)
6. N8N
7. IA

### Condiciones.
todos los equipos deben crear la interfaz de usuario, pagina y admin que incluyan todos los servicios, pero cada vps y, por lo tanto, cada dominio solo va a administrar su propia base de datos y un servicio del total. La idea es competir por la mejor aplicacion.

### Servicio asignado
* Proveer bases de datos SQL server.

### Que se espera
Asumo, que ahora todas las vps se van a comportar como un cluster. Cuando una persona entre a raft.andrescortez.dev va a poder crear base de datos en cualquier motor, usar servicios de DNS, N8N e IA, pero nuestra vps solo va tener un contenedor de SQL server con el motor que va a proveer bases de datos para todos los usuarios que intenten crear una db desde cualquiera de los otros 8 dominios y sus correspondientes interfaces. Supo que en nuestra pagina, al elegir crear una base de datos de MySql, debemos madar esa peticion a la vps con el backend que amdinistra ese servicios.


