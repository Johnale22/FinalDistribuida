El microservicio de autenticación se conecta con el microservicio de User Management para validar las credenciales del usuario.

JWT se genera y se pasa al cliente para su uso en las solicitudes futuras. El token JWT también es utilizado por el microservicio de Authorization para verificar el acceso.