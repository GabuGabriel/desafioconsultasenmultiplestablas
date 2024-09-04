1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido.
    
Crear una base de datos llamada desafio3_Gabriel_Muñoz_420 con las siguientes tablas.

CREATE DATABASE desafio3_Gabriel_Munoz_420;

\c desafio3_gabriel_munoz_420
    
Primera tabla
Usuarios con los campos: 
id, email, nombre, apellido, rol

Donde:
El id es serial.
El rol es un varchar que puede ser administrador o usuario, no es necesario limitarlo
de ninguna forma para el ejercicio.
Los otros campos debes definirlo utilizando tu mejor criterio.
Luego ingresa 5 usuarios en la base de datos, debe haber al menos un usuario con el rol de
administrador.

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('juan.perez@example.com', 'Juan', 'Perez', 'administrador'),
('maria.garcia@example.com', 'Maria', 'Garcia', 'usuario'),
('luis.martinez@example.com', 'Luis', 'Martinez', 'usuario'),
('ana.rodriguez@example.com', 'Ana', 'Rodriguez', 'usuario'),
('pedro.sanchez@example.com', 'Pedro', 'Sanchez', 'usuario');

------------------------------------------------------------------
segunda tabla
Post con los campos:
id, titulo, contenido, fecha_creacion, fecha_actualizacion, descatado, usuario_id

Donde:
fecha_creacion y fecha_actualizacion son de tipo timestamp.
destacado es boolean (true o false).
usuario_id es un bigint y se utilizará para conectarlo con el usuario que escribió el
post.
El título debe ser de tipo varchar.
El contenido debe ser de tipo text.
Luego, ingresa 5 posts:
El post con id 1 y 2 deben pertenecer al usuario administrador.
El post 3 y 4 asignarlos al usuario que prefieras (no puede ser el administrador).
El post 5 no debe tener un usuario_id asignado.

CREATE TABLE Post (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN DEFAULT FALSE,
    usuario_id BIGINT REFERENCES Usuarios(id)
);

INSERT INTO Post (titulo, contenido, destacado, usuario_id) VALUES
('Primer Post de Administrador', 'Contenido del primer post de administrador', TRUE, 1),
('Segundo Post de Administrador', 'Contenido del segundo post de administrador', FALSE, 1),
('Post de Usuario 1', 'Contenido del post de usuario 1', FALSE, 2),
('Post de Usuario 2', 'Contenido del post de usuario 2', TRUE, 3),
('Post No Asignado', 'Contenido del post no asignado', FALSE, NULL);

------------------------------------------------------------------
tercera tabla 
Comentarios con los campos:
id, contenido, fecha_creacion, usuario_id, post_id

Donde:
fecha_creacion es un timestamp.
usuario_id es un bigint y se utilizará para conectarlo con el usuario que escribió el
comentario.
post_id es un bigint y se utilizará para conectarlo con post_id.
Luego ingresa 5 comentarios
Los comentarios con id 1,2 y 3 deben estar asociados al post 1, a los usuarios 1, 2 y
3 respectivamente.
Los comentarios 4 y 5 deben estar asociados al post 2, a los usuarios 1 y 2
respectivamente.

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT REFERENCES Usuarios(id),
    post_id BIGINT REFERENCES Post(id)
);

INSERT INTO Comentarios (contenido, usuario_id, post_id) VALUES
('Comentario 1 en Post 1', 1, 1),
('Comentario 2 en Post 1', 2, 1),
('Comentario 3 en Post 1', 3, 1),
('Comentario 1 en Post 2', 1, 2),
('Comentario 2 en Post 2', 2, 2);

2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
nombre y email del usuario junto al título y contenido del post.

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM Usuarios u
JOIN Post p ON u.id = p.usuario_id;
 nombre |           email           |            titulo             |                  contenido
--------+---------------------------+-------------------------------+---------------------------------------------
 Juan   | juan.perez@example.com    | Primer Post de Administrador  | Contenido del primer post de administrador
 Juan   | juan.perez@example.com    | Segundo Post de Administrador | Contenido del segundo post de administrador
 Maria  | maria.garcia@example.com  | Post de Usuario 1             | Contenido del post de usuario 1
 Luis   | luis.martinez@example.com | Post de Usuario 2             | Contenido del post de usuario 2
(4 rows)

3. Muestra el id, título y contenido de los posts de los administradores.
a. El administrador puede ser cualquier id.

SELECT p.id, p.titulo, p.contenido
FROM Post p
JOIN Usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';
 id |            titulo             |                  contenido
----+-------------------------------+---------------------------------------------
  1 | Primer Post de Administrador  | Contenido del primer post de administrador
  2 | Segundo Post de Administrador | Contenido del segundo post de administrador
(2 rows)

4. Cuenta la cantidad de posts de cada usuario.
a. La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario.
Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con
todas y con eso determina cuál es la correcta. No da lo mismo la tabla desde la que
se parte.

SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM Usuarios u
LEFT JOIN Post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;
 id |           email           | cantidad_posts
----+---------------------------+----------------
  3 | luis.martinez@example.com |              1
  5 | pedro.sanchez@example.com |              0
  4 | ana.rodriguez@example.com |              0
  2 | maria.garcia@example.com  |              1
  1 | juan.perez@example.com    |              2
(5 rows)

5. Muestra el email del usuario que ha creado más posts.
a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email
FROM Usuarios u
JOIN Post p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;
         email
------------------------
 juan.perez@example.com
(1 row)

6. Muestra la fecha del último post de cada usuario.
Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT u.email, MAX(p.fecha_creacion) AS ultima_publicacion
FROM Usuarios u
LEFT JOIN Post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;
           email           |     ultima_publicacion
---------------------------+----------------------------
 luis.martinez@example.com | 2024-09-03 23:47:21.986706
 pedro.sanchez@example.com |
 ana.rodriguez@example.com |
 maria.garcia@example.com  | 2024-09-03 23:47:21.986706
 juan.perez@example.com    | 2024-09-03 23:47:21.986706
(5 rows)

7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido
FROM Post p
JOIN Comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;
            titulo            |                 contenido
------------------------------+--------------------------------------------
 Primer Post de Administrador | Contenido del primer post de administrador
(1 row)

8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.

SELECT p.titulo, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM Post p
LEFT JOIN Comentarios c ON p.id = c.post_id
LEFT JOIN Usuarios u ON c.usuario_id = u.id;
            titulo             |               contenido_post                |  contenido_comentario  |           email 
-------------------------------+---------------------------------------------+------------------------+---------------------------
 Primer Post de Administrador  | Contenido del primer post de administrador  | Comentario 1 en Post 1 | juan.perez@example.com
 Primer Post de Administrador  | Contenido del primer post de administrador  | Comentario 2 en Post 1 | maria.garcia@example.com
 Primer Post de Administrador  | Contenido del primer post de administrador  | Comentario 3 en Post 1 | luis.martinez@example.com
 Segundo Post de Administrador | Contenido del segundo post de administrador | Comentario 1 en Post 2 | juan.perez@example.com
 Segundo Post de Administrador | Contenido del segundo post de administrador | Comentario 2 en Post 2 | maria.garcia@example.com
 Post No Asignado              | Contenido del post no asignado              |                        |
 Post de Usuario 2             | Contenido del post de usuario 2             |                        |
 Post de Usuario 1             | Contenido del post de usuario 1             |                        |
(8 rows)

9. Muestra el contenido del último comentario de cada usuario.

SELECT u.nombre, u.apellido, c.contenido
FROM Usuarios u
LEFT JOIN (
    SELECT DISTINCT ON (usuario_id) *
    FROM Comentarios
    ORDER BY usuario_id, fecha_creacion DESC
) c ON u.id = c.usuario_id
ORDER BY u.id;
 nombre | apellido  |       contenido
--------+-----------+------------------------
 Juan   | Perez     | Comentario 1 en Post 1
 Maria  | Garcia    | Comentario 2 en Post 1
 Luis   | Martinez  | Comentario 3 en Post 1
 Ana    | Rodriguez |
 Pedro  | Sanchez   |
(5 rows)

10. Muestra los emails de los usuarios que no han escrito ningún comentario.
Hint: Recuerda el uso de Having

SELECT u.email
FROM Usuarios u
LEFT JOIN Comentarios c ON u.id = c.usuario_id
GROUP BY u.id, u.email
HAVING COUNT(c.id) = 0;
           email
---------------------------
 pedro.sanchez@example.com
 ana.rodriguez@example.com
(2 rows)
