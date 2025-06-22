El microservicio de auditoría y logs registra todas las acciones importantes, como el login exitoso, actualizaciones de perfil, cambios de contraseña y acciones de autorización.

Los microservicios de User Management, Authentication, Authorization y Password Recovery envían registros de sus acciones al microservicio de Audit & Logs para llevar un historial.