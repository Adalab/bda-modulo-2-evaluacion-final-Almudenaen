USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS Nombre_pelicula
FROM sakila.film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title Nombre_pelicula, rating Clasificacion
FROM film f
WHERE f.rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title Nombre_pelicula, description Descripción
FROM film 
WHERE description LIKE "%amazing%";
 
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title "Nombre película" , length Duración
FROM film 
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.
SELECT CONCAT(first_name, " ", last_name) "Nombre actriz/actor"
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

WITH Actores_Gibson AS (
    SELECT CONCAT(first_name, " ", last_name) `Nombre actriz/actor` FROM actor
    )
SELECT `Nombre actriz/actor` FROM Actores_Gibson WHERE `Nombre actriz/actor` LIKE "%Gibson%";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT actor_id, first_name Nombre
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT title Título, rating Clasificación
FROM film
WHERE rating NOT IN ("R","PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating Clasificación, COUNT(title) 'Cantidad de películas'
FROM film
GROUP BY rating
ORDER BY COUNT(title) ASC;

/*10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT c.customer_id "ID del cliente", c.first_name Nombre, c.last_name Apellido, 
COUNT(DISTINCT i.film_id) "Cantidad de películas alquiladas" -- Entiendo que el enunciado pide películas únicas
FROM customer c
JOIN rental r
ON r.customer_id = c.customer_id
JOIN inventory i
ON i.inventory_id = r.inventory_id
GROUP BY r.customer_id;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
categoría junto con el recuento de alquileres.*/

SELECT c.name categoría, COUNT(r.rental_id) recuento_de_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.name;

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/
SELECT rating Clasificación, ROUND(AVG(length)) promedio
FROM film
GROUP BY rating;  


/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
SELECT CONCAT(a.first_name, ' ', a.last_name) Nombre_y_apellido
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
WHERE f.title = "Indian Love";

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
SELECT title título
FROM film
WHERE description LIKE ("%DOG%") 
OR description LIKE ("%CAT%");

/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/

SELECT CONCAT(a.first_name, ' ', a.last_name) Nombre_y_apellido, COUNT(f.title) Aparición_en_películas
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
GROUP BY a.actor_id
HAVING COUNT(f.title) = 0
UNION		
SELECT 'No hay resultados', 'No hay resultados'			-- Para que en lugar de una tabla vacía aparezca una fila indicando que no hay resultados
LIMIT 1;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title Título
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS Nombre_y_apellido, COUNT(fa.film_id) AS total_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id			-- No uso NATURAL JOIN porque la columna actor_id puede no contener las mismas filas en ambas tablas
GROUP BY a.actor_id, a.first_name, a.last_name   		-- Agrupo por actor_id porque es PK y asegura que no se agrupan actores con el mismo nombre y apellido
HAVING COUNT(fa.film_id) > 10;							-- Uso HAVING en vez de WHERE porque la condición no es sobre las tablas originales sino sobre la consulta


-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title Título, rating Clasificación, length Duración
FROM film
WHERE rating = "R"  AND length > 120;

/*20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
minutos y muestra el nombre de la categoría junto con el promedio de duración.*/
SELECT c.name Categoría, ROUND(AVG(f.length)) Promedio_duración 		-- Hago la media y redondeo los datos de la columna length
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name											-- Agrupo las medias de la columna length basándome en la columna c.category_id
HAVING ROUND(AVG(f.length)) > 120;										-- Uso el HAVING para establecer una condición dentro de la tabla agrupada con GROUP BY


/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
junto con la cantidad de películas en las que han actuado.*/

SELECT CONCAT(first_name, ' ', last_name) Nombre_y_apellido, COUNT(film_id) Cantidad_de_películas
FROM actor
INNER JOIN film_actor fa
USING (actor_id)
GROUP BY actor_id
HAVING COUNT(film_id) > 5;

/*22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final) */

SELECT title Película, ROUND(AVG(DATEDIFF(return_date,rental_date))) Media_días_alquiler 
FROM film 
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
WHERE rental_id IN (					-- Condición: que los datos de la columna rental_id original aparezcan en la columna de la tabla temporal de la subconsulta
    SELECT rental_id								-- En la subconsulta indico la columna de la que quiero los datos
    FROM rental
    WHERE DATEDIFF(return_date,rental_date) > 5	-- Condición que deben cumplir los datos que devuelva la subconsulta
)
GROUP BY title;

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
SELECT CONCAT(first_name, ' ', last_name) Nombre_y_apellidos
FROM actor
WHERE actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    JOIN film_category USING(film_id)
    JOIN category USING(category_id)
    WHERE name = 'Horror'
);
