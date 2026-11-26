# Restaurante Beta

Aplicación web para gestionar la operación básica de un restaurante. Reúne en un solo sistema el registro de usuarios, inicio de sesión, administración del menú, reservas y pedidos por delivery.

> Es un proyecto académico en Java EE. Algunas funciones de delivery todavía están en desarrollo; el carrito y la creación final del pedido se encuentran simulados.

## ¿Qué permite hacer?

**Usuarios**

- Registrarse, iniciar y cerrar sesión.
- Consultar el menú disponible.
- Crear reservas indicando fecha, hora y cantidad de personas.
- Entrar a la sección de delivery.

**Administradores**

- Crear, buscar, editar y eliminar platos del menú.
- Consultar reservas, filtrarlas por fecha, cambiar su estado o eliminarlas.
- Consultar pedidos, cambiar su estado y ver estadísticas.
- Registrar otras cuentas de administrador.

## Tecnologías

| Tecnología | Versión / uso |
| --- | --- |
| Java | 8 |
| Java EE | 8 |
| Servlets | 4.0.1 |
| JSP + JSTL | Vistas dinámicas; JSTL 1.2 |
| Maven | Compilación y dependencias |
| MySQL Connector/J | 8.0.23 |
| BCrypt | 0.4, cifrado de contraseñas |
| Gson | 2.10.1 |
| WAR | Formato de despliegue |

## Arquitectura

El proyecto sigue una separación similar a **MVC**:

- **Modelo:** clases de dominio como `Usuario`, `Menu`, `Reserva` y `Pedido`.
- **Vista:** páginas JSP dentro de `src/main/webapp`.
- **Controlador:** servlets que reciben las solicitudes y coordinan cada operación.
- **DAO:** acceso a MySQL mediante JDBC y consultas SQL.
- **Utilidades:** conexión a la base de datos y manejo de contraseñas.

```text
src/main/
├── java/
│   ├── controlador/   # Servlets
│   ├── dao/           # Acceso a datos
│   ├── modelo/        # Entidades del negocio
│   └── util/          # Conexión y seguridad
├── resources/         # Configuración
└── webapp/            # JSP y archivos web
```

## Cómo ejecutarlo

### Requisitos

- JDK 8
- Maven 3
- MySQL
- Un servidor compatible con Servlet 4.0, por ejemplo Tomcat 9

### Pasos

1. Clona el repositorio:

   ```bash
   git clone https://github.com/Body124235/restaurantebeta.git
   cd restaurantebeta
   ```

2. Crea en MySQL una base de datos llamada `restaurante_db`.

3. Configura el usuario y la contraseña de MySQL en:

   ```text
   src/main/java/util/ConexionBD.java
   ```

   La aplicación espera las tablas `usuarios`, `menus`, `reservas`, `pedidos` e `items_pedido`. Por el momento, el repositorio no incluye un script SQL para crearlas.

4. Compila el proyecto:

   ```bash
   mvn clean package
   ```

5. Despliega `target/Restaurante-1.0-SNAPSHOT.war` en tu servidor y abre la aplicación desde el navegador.

## Estado actual

El módulo de usuarios, menú y reservas contiene las operaciones principales. La sección de delivery permite visualizar información y administrar pedidos existentes, pero agregar al carrito y registrar un pedido completo aún requiere implementación.

---

Hecho como una solución sencilla para organizar la atención y administración de un restaurante.
