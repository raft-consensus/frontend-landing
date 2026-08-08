
Me gusta mucho la dirección que está tomando la identidad de **Raft**. El logo ya comunica muy bien la idea: mar, tecnología, bases de datos e IA. Ahora la aplicación debería sentirse como una extensión natural del logo.

Mi recomendación es que no tengas simplemente un **modo claro** y un **modo oscuro**, sino dos identidades:

* 🌊 **Raft Day** → limpio, amigable, productivo.
* 🌌 **Raft Night** → moderno, profundo, con sensación de infraestructura cloud.

No cambiaría los colores de marca principales; solo el contexto donde viven.

---

# 🌊 Raft Day

Inspirado en navegación, madera clara y océano.

| Uso            | Color      | Hex               |
| -------------- | ---------- | ----------------- |
| Primary        | Navy       | **#0D3B66** |
| Primary Hover  | Ocean Blue | **#165D9C** |
| Secondary      | Teal       | **#2A9D8F** |
| Accent         | Sky Blue   | **#59B9E6** |
| Background     | Off White  | **#F8FAFC** |
| Surface        | White      | **#FFFFFF** |
| Border         | Soft Gray  | **#D8E2EC** |
| Text Primary   | Navy       | **#17324D** |
| Text Secondary | Slate      | **#5C7187** |

### Colores de los servicios

Mantendría exactamente los del logo.

MySQL

🟧 **#F28C28**

SQL Server

🟥 **#D64545**

MongoDB

🟩 **#2F9E6D**

PostgreSQL

🟦 **#2C7BC9**

---

## Estados

Success

**#2F9E6D**

Warning

**#F2A93B**

Error

**#D64545**

Info

**#4EA5D9**

---

# 🌌 Raft Night

Aquí no usaría negro.

Muchos productos modernos (GitHub, Linear, Raycast, Vercel) usan un azul muy oscuro.

Eso combina perfecto con el mar.

| Uso            | Color       | Hex               |
| -------------- | ----------- | ----------------- |
| Background     | Midnight    | **#09131F** |
| Surface        | Deep Navy   | **#102235** |
| Card           | Ocean Night | **#183247** |
| Primary        | Sky Blue    | **#5AB8FF** |
| Secondary      | Aqua        | **#4EC8B8** |
| Border         | Navy Gray   | **#28465F** |
| Text           | White       | **#F5FAFF** |
| Text Secondary | Gray Blue   | **#A5BDD2** |

---

# Colores de marca en Dark Mode

No cambiaría los colores de las bases de datos.

Simplemente los haría ligeramente más luminosos.

Orange

**#F39C3D**

Red

**#E05A5A**

Green

**#41B883**

Blue

**#4EA5FF**

Así resaltan sin parecer fluorescentes.

---

# 🌊 Colores para botones

Botón Principal

```
Background

#0D3B66

Texto

#FFFFFF
```

Hover

```
#165D9C
```

---

Botón Secundario

```
Background

#2A9D8F

Texto

White
```

---

Botón Ghost

```
Background

Transparent

Texto

#0D3B66
```

---

# Inputs

Modo claro

```
Background

White

Border

#D8E2EC

Focus

#2A9D8F
```

Modo oscuro

```
Background

#102235

Border

#28465F

Focus

#5AB8FF
```

---

# Logo modo oscuro

Creo que aquí puedes hacer algo muy bonito.

No cambiaría los colores de los servicios.

Solo adaptaría el resto.

## Madera

Más oscura

```
#6B4F34
```

## Vela

Dejaría de ser crema.

La convertiría en un azul muy oscuro.

```
#17324D
```

o

```
#1C2D44
```

---

## Nombre Raft

Pasaría de azul oscuro a casi blanco.

```
#F5FAFF
```

---

## Circuitos n8n

En lugar de verde agua.

```
#58D1D1
```

Muy suaves.

---

## Globo DNS

Más brillante.

```
#5AB8FF
```

---

## IA

Mantendría el azul actual, pero ligeramente más claro.

```
#6BC3FF
```

Con circuitos navy.

---

# Estilo general

Lo que más transmite el logo es **confianza**, no agresividad. Por eso evitaría gradientes fuertes o colores neón. La interfaz debería sentirse:

* 🌊 Marítima.
* ☁️ Cloud.
* 🗄️ Infraestructura.
* 🤖 IA moderna.
* 📚 Amigable para estudiantes.
* 💼 Lo suficientemente profesional para que una empresa también la use.

## Recomendación para Flutter

Te sugiero definir un único archivo de tokens de diseño (por ejemplo `app_colors.dart`) con ambas paletas y derivar los `ThemeData` desde ahí. Mantén los colores de marca (navy, teal y los cuatro colores de servicios) constantes entre ambos temas, cambiando únicamente los fondos, superficies y textos. Eso hará que cambiar entre web, Android e iOS sea consistente y muy fácil de mantener.

Con el logo que has conseguido, una interfaz inspirada en productos como Linear, GitHub, Supabase y Vercel, pero con una personalidad marítima propia, puede darle a **Raft** una identidad muy reconocible.
