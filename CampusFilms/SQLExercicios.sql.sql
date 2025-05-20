-- DIFICULTAD: Muy fácil
-- 1- Devuelve todas las películas

SELECT * FROM MOVIES;

-- 2- Devuelve todos los géneros existentes

SELECT genre_name FROM GENRES;

-- 3- Devuelve la lista de todos los estudios de grabación que estén activos

SELECT studio_name FROM STUDIOS WHERE STUDIO_ACTIVE = 1;

-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma

SELECT USER_NAME AS USERS FROM USERS 
ORDER BY USER_JOIN_DATE DESC
LIMIT 20;

-- DIFICULTAD: Fácil
-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor

SELECT MOVIE_DURATION AS MOVIE, COUNT(MOVIE_ID) AS FRECUENCIA FROM MOVIES
GROUP BY MOVIE_DURATION
ORDER BY MOVIE DESC
LIMIT 20;

-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.

SELECT MOVIE_NAME AS NAME FROM MOVIES
WHERE YEAR(MOVIE_RELEASE_DATE) >= 2000 AND MOVIE_NAME LIKE 'A%'; 

-- 7- Devuelve los actores nacidos un mes de Junio

SELECT ACTOR_NAME AS ACTOR FROM ACTORS
WHERE MONTH(ACTOR_BIRTH_DATE) = 06;

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos

SELECT ACTOR_NAME AS ACTOR FROM ACTORS
WHERE MONTH(ACTOR_BIRTH_DATE) != 06 AND ACTOR_DEAD_DATE IS NULL;

-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos

SELECT DIRECTOR_NAME AS DIRECTOR, DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, CURRENT_DATE) AS EDAD
FROM DIRECTORS
WHERE DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, CURRENT_DATE) >= 50 AND DIRECTOR_DEAD_DATE IS NULL;

-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido

SELECT ACTOR_NAME AS ACTOR, DATEDIFF('YEAR', ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) AS EDAD
FROM ACTORS
WHERE DATEDIFF('YEAR', ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) < 50 AND ACTOR_DEAD_DATE IS NOT NULL;

-- 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos

SELECT DIRECTOR_NAME AS DIRECTOR, DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, CURRENT_DATE) AS EDAD
FROM DIRECTORS
WHERE DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, CURRENT_DATE) <= 40 AND DIRECTOR_DEAD_DATE IS NULL;

-- 12- Indica la edad media de los directores vivos

SELECT AVG(DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, CURRENT_DATE)) AS EDAD_MEDIA
FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL;

-- 13- Indica la edad media de los actores que han fallecido

SELECT AVG(DATEDIFF('YEAR', ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE)) AS EDAD_MEDIA
FROM ACTORS
WHERE ACTOR_DEAD_DATE IS NOT NULL;

-- DIFICULTAD: Media
-- 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado

SELECT M.MOVIE_NAME AS MOVIE, S.STUDIO_NAME AS STUDIO
FROM MOVIES M JOIN STUDIOS S
ON M.STUDIO_ID = S.STUDIO_ID;

-- 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015

SELECT DISTINCT U.USER_NAME AS USER
FROM USERS U JOIN USER_MOVIE_ACCESS UM
ON U.USER_ID = UM.USER_ID
WHERE YEAR(ACCESS_DATE) BETWEEN 2010 AND 2015;

-- 16- Devuelve cuantas películas hay de cada país

SELECT COUNT(*) AS NUMERO_PELICULAS, N.NATIONALITY_NAME AS NATIONALITIES
FROM MOVIES M JOIN NATIONALITIES N
ON M.NATIONALITY_ID = N.NATIONALITY_ID
GROUP BY NATIONALITIES ;

-- 17- Devuelve todas las películas que hay de género documental

SELECT M.MOVIE_NAME AS MOVIES
FROM MOVIES M JOIN GENRES G
ON M.GENRE_ID = G.GENRE_ID
WHERE GENRE_NAME = 'Documentary';

-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos

SELECT M.MOVIE_NAME AS MOVIES, D.DIRECTOR_NAME AS DIRECTOR
FROM MOVIES M JOIN DIRECTORS D
ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE YEAR(D.DIRECTOR_BIRTH_DATE) >= 1980 AND D.DIRECTOR_DEAD_DATE IS NULL;

-- 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores

SELECT DISTINCT D.DIRECTOR_BIRTH_PLACE AS CITY
FROM DIRECTORS D
JOIN MOVIES M ON D.DIRECTOR_ID = M.DIRECTOR_ID
JOIN USER_MOVIE_ACCESS UMA ON M.MOVIE_ID = UMA.MOVIE_ID
JOIN USERS U ON UMA.USER_ID = U.USER_ID
WHERE D.DIRECTOR_BIRTH_PLACE = U.USER_TOWN;


SELECT DIRECTOR_BIRTH_PLACE
FROM DIRECTORS D JOIN USERS U
ON D.DIRECTOR_BIRTH_PLACE = U.USER_TOWN;


--20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo

SELECT m.MOVIE_NAME AS NAME, EXTRACT(YEAR FROM m.MOVIE_RELEASE_DATE) AS YEAR
FROM PUBLIC.MOVIES m 
WHERE m.STUDIO_ID in (SELECT s.STUDIO_ID
					FROM public.STUDIOS s 
					WHERE s.STUDIO_ACTIVE = '0');

-- 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido

SELECT M.MOVIE_NAME AS MOVIE, UMA.ACCESS_DATE
FROM PUBLIC.USER_MOVIE_ACCESS UMA JOIN PUBLIC.MOVIES M 
ON UMA.MOVIE_ID = M.MOVIE_ID
ORDER BY UMA.ACCESS_DATE DESC
LIMIT 10;

-- 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años

SELECT COUNT(M.MOVIE_ID) AS NUM_MOVIE, D.DIRECTOR_NAME AS DIRECTOR
FROM PUBLIC.DIRECTORS d JOIN PUBLIC.MOVIES m 
ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE DATEDIFF('YEAR', DIRECTOR_BIRTH_DATE, M.MOVIE_RELEASE_DATE) < 41
GROUP BY M.DIRECTOR_NAME;

-- 23- Indica cuál es la media de duración de las películas de cada director

SELECT AVG(M.MOVIE_DURATION ) AS AVG_MOVIE, D.DIRECTOR_NAME AS DIRECTOR
FROM PUBLIC.DIRECTORS d JOIN PUBLIC.MOVIES m 
ON m.DIRECTOR_ID = d.DIRECTOR_ID
GROUP BY M.DIRECTOR_NAME;

/* 24- Indica cuál es el nombre y la duración mínima de las películas a las que se ha accedido en 
 * los últimos 2 años por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)*/

SELECT M.MOVIE_NAME AS MOVIE, MIN(M.MOVIE_DURATION) AS DURATION
FROM PUBLIC.MOVIES m JOIN PUBLIC.USER_MOVIE_ACCESS uma 
ON M.MOVIE_ID = UMA.MOVIE_ID
WHERE UMA.ACCESS_DATE BETWEEN '2017-01-25' AND '2019-01-25'
GROUP BY m.MOVIE_NAME ;

-- 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título

SELECT D.DIRECTOR_NAME AS DIRECTOR, COUNT(M.MOVIE_ID) AS NUM_MOVIES
FROM PUBLIC.MOVIES M 
JOIN PUBLIC.DIRECTORS D ON D.DIRECTOR_ID = M.DIRECTOR_ID
WHERE YEAR(M.MOVIE_RELEASE_DATE) BETWEEN 1960 AND 1989
  AND UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY D.DIRECTOR_NAME;


-- DIFICULTAD: Difícil
-- 26- Lista nombre, nacionalidad y director de todas las películas

SELECT M.MOVIE_NAME AS TITLE, N.NATIONALITY_NAME AS NATIONALITY, D.DIRECTOR_NAME AS DIRECTOR
FROM PUBLIC.MOVIES m JOIN PUBLIC.DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID
JOIN PUBLIC.NATIONALITIES n ON n.NATIONALITY_ID = m.NATIONALITY_ID;

-- 27- Muestra las películas con los actores que han participado en cada una de ellas

SELECT M.MOVIE_NAME AS TITLE, A.ACTOR_NAME AS ACTOR
FROM PUBLIC.MOVIES m JOIN PUBLIC.MOVIES_ACTORS ma  
ON M.MOVIE_ID = MA.MOVIE_ID
JOIN PUBLIC.ACTORS a ON a.ACTOR_ID = ma.ACTOR_ID;


-- 28- Indica cual es el nombre del director del que más películas se ha accedido

SELECT d.director_name AS name_director
FROM public.directors d
JOIN public.movies m ON d.director_id = m.director_id
JOIN public.user_movie_access uma ON m.movie_id = uma.movie_id
GROUP BY d.director_id
ORDER BY COUNT(uma.movie_id) DESC
LIMIT 1;

-- 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado

SELECT COUNT(A.MOVIE_ID) AS NUM_MOVIES, S.STUDIO_NAME AS STUDIO
FROM PUBLIC.MOVIES M JOIN PUBLIC.STUDIOS s ON M.STUDIO_ID  = S.STUDIO_ID
JOIN PUBLIC.AWARDS a ON a.MOVIE_ID = M.MOVIE_ID
GROUP BY S.STUDIO_ID;

-- 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
-- (Si una película está nominada a un premio, su actor también lo está)

SELECT A.ACTOR_NAME AS ACTOR, COUNT(AW.AWARD_ALMOST_WIN) AS ALMOST_WIN
FROM PUBLIC.ACTORS a JOIN PUBLIC.MOVIES_ACTORS ma ON A.ACTOR_ID = MA.ACTOR_ID
JOIN PUBLIC.MOVIES m ON MA.MOVIE_ID = M.MOVIE_ID
JOIN PUBLIC.AWARDS AW ON AW.MOVIE_ID = M.MOVIE_ID
GROUP BY ACTOR_NAME ;

-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos

SELECT COUNT(DISTINCT a.ACTOR_ID) AS NUM_ACTORS, COUNT(DISTINCT d.DIRECTOR_ID) AS NUM_DIRECTORS
FROM PUBLIC.ACTORS a JOIN PUBLIC.MOVIES_ACTORS ma ON A.ACTOR_ID = MA.ACTOR_ID
JOIN PUBLIC.MOVIES m ON m.MOVIE_ID = ma.MOVIE_ID
JOIN PUBLIC.DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE M.STUDIO_ID IN (SELECT S.STUDIO_ID
					FROM PUBLIC.STUDIOS s
					WHERE S.STUDIO_ACTIVE = '0');

-- 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma 
-- que hayan accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50

SELECT u.USER_NAME AS NAME, U.USER_TOWN AS TOWN, U.USER_PHONE AS PRHONE_NUMBER
FROM PUBLIC.USERS u JOIN PUBLIC.USER_MOVIE_ACCESS uma ON U.USER_ID = UMA.USER_ID
JOIN PUBLIC.MOVIES m ON m.MOVIE_ID = uma.MOVIE_ID
WHERE m.MOVIE_ID IN (SELECT AW.MOVIE_ID 
					FROM PUBLIC.AWARDS AW 
					WHERE 
						AW.AWARD_NOMINATION > 150 AND 
           				AW.AWARD_WIN < 50);

-- 33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)

SELECT M.MOVIE_NAME AS TITLE, M.MOVIE_RELEASE_DATE AS RELEASE_DATE, D.DIRECTOR_NAME AS DIRECTOR, D.DIRECTOR_DEAD_DATE AS DIRECTOR_DEATH
FROM PUBLIC.MOVIES m JOIN PUBLIC.DIRECTORS d  
ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE M.MOVIE_RELEASE_DATE > D.DIRECTOR_DEAD_DATE;

-- 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)

UPDATE PUBLIC.DIRECTORS D
SET DIRECTOR_DEAD_DATE = (
    SELECT DATEADD('DAY', 365, MAX(MOVIE_RELEASE_DATE))
    FROM PUBLIC.MOVIES M
    WHERE M.DIRECTOR_ID = D.DIRECTOR_ID
      AND M.MOVIE_RELEASE_DATE > D.DIRECTOR_DEAD_DATE
)
WHERE EXISTS (
    SELECT 1
    FROM PUBLIC.MOVIES M1
    WHERE M1.DIRECTOR_ID = D.DIRECTOR_ID
      AND M1.MOVIE_RELEASE_DATE > D.DIRECTOR_DEAD_DATE
);

-- DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

SELECT D.DIRECTOR_NAME AS DIRECTOR, G.GENRE_NAME AS GENRE
FROM PUBLIC.DIRECTORS d JOIN PUBLIC.MOVIES m 
ON D.DIRECTOR_ID = M.MOVIE_ID
JOIN PUBLIC.GENRES g ON M.GENRE_ID = G.GENRE_ID
GROUP BY G.GENRE_ID, D.DIRECTOR_ID
ORDER BY D.DIRECTOR_NAME ASC;

-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas



-- 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad


