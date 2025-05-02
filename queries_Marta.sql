USE musicstream;

-- ¿Cuál es el artista con más albums?

SELECT
	artists.artist_name,
	COUNT(DISTINCT tracks.album_id) AS Total_albums
FROM artists
INNER JOIN tracks
	ON artists.artist_id = tracks.artist_id
GROUP BY tracks.artist_id
ORDER BY Total_albums DESC
LIMIT 1;

-- ¿Qué género es el mejor valorado?

SELECT
	genres.genre_name,
	tracks.popularity
FROM genres
INNER JOIN artist_genres
	ON genres.genre_id = artist_genres.genre_id
INNER JOIN tracks
	ON artist_genres.artist_id = tracks.artist_id
ORDER BY popularity DESC
LIMIT 1;


-- ¿En qué año se lanzaron más álbumes?

SELECT
	YEAR(release_date) AS Anio,
	COUNT(album_id) AS "Total lanzamientos"
FROM albums
GROUP BY Anio
ORDER BY COUNT(album_id) DESC
LIMIT 1;

-- ¿Cuál es la canción mejor valorada?

SELECT
	track_name,
	popularity
FROM tracks
ORDER BY popularity DESC
LIMIT 1;

-- ¿Cuál es el artista con más valoración?

SELECT
	artists.artist_name,
	tracks.popularity
FROM artists
INNER JOIN tracks
	ON artists.artist_id = tracks.artist_id
ORDER BY popularity DESC
LIMIT 1;



-- ¿Qué país tiene más artistas? (ordenar por popularidad)

SELECT
    market_track.market_id,
    COUNT(DISTINCT tracks.artist_id) AS total_artists,
    AVG(tracks.popularity) AS avg_popularity
FROM market_track
INNER JOIN tracks 
	ON tracks.track_id = market_track.track_id
GROUP BY market_track.market_id
ORDER BY avg_popularity DESC
LIMIT 1;

-- ¿Cuál es el álbum con más canciones? 

SELECT
	album_name,
	total_tracks
FROM albums
ORDER BY total_tracks DESC
LIMIT 1;

-- ¿Qué artista ha publicado canciones en más mercados diferentes?

SELECT
    artists.artist_id,
    artists.artist_name,
    COUNT(DISTINCT market_track.market_id) AS total_market
FROM artists
INNER JOIN tracks 
	ON artists.artist_id = tracks.artist_id
INNER JOIN market_track 
	ON market_track.track_id = tracks.track_id
GROUP BY artists.artist_id, artists.artist_name
ORDER BY total_market DESC
LIMIT 1;

-- ¿Qué canción tiene más presencia global? 

SELECT
	tracks.track_id,
	tracks.track_name,
	COUNT(DISTINCT market_track.market_id) AS total_market
FROM tracks
INNER JOIN market_track
	ON market_track.track_id = tracks.track_id
GROUP BY tracks.track_id, tracks.track_name
ORDER BY total_market DESC
LIMIT 1;

-- Top 5 artistas con más canciones populares 

SELECT
    artists.artist_id,
    artists.artist_name,
    COUNT(tracks.track_id) AS popular_tracks
FROM artists
INNER JOIN tracks 
	ON artists.artist_id = tracks.artist_id
WHERE tracks.popularity > 70
GROUP BY artists.artist_id, artists.artist_name
ORDER BY popular_tracks DESC
LIMIT 5;


-- ¿Qué artista tiene más canciones asociadas a géneros diferentes?

SELECT
	artists.artist_id,
    artists.artist_name,
    COUNT(DISTINCT artist_genres.genre_id) AS total_genres
FROM artists
INNER JOIN artist_genres
	ON artists.artist_id = artist_genres.artist_id
GROUP BY artists.artist_id, artists.artist_name
ORDER BY total_genres DESC
LIMIT 1;

-- Top 3 canciones más populares por género

SELECT * FROM (
    SELECT 
		genres.genre_name, 
		tracks.track_name, 
		tracks.popularity
    FROM tracks
    JOIN artist_genres 
		ON tracks.artist_id = artist_genres.artist_id
    JOIN genres 
		ON artist_genres.genre_id = genres.genre_id
    WHERE genres.genre_name = 'rock'
    ORDER BY tracks.popularity DESC
    LIMIT 3
) AS rock_top

UNION

SELECT * FROM (
    SELECT genres.genre_name, tracks.track_name, tracks.popularity
    FROM tracks
    JOIN artist_genres 
		ON tracks.artist_id = artist_genres.artist_id
    JOIN genres 
		ON artist_genres.genre_id = genres.genre_id
    WHERE genres.genre_name = 'pop'
    ORDER BY tracks.popularity DESC
    LIMIT 3
) AS pop_top

UNION

SELECT * FROM (
    SELECT genres.genre_name, tracks.track_name, tracks.popularity
    FROM tracks
    JOIN artist_genres 
		ON tracks.artist_id = artist_genres.artist_id
    JOIN genres 
    ON artist_genres.genre_id = genres.genre_id
    WHERE genres.genre_name = 'hip hop'
    ORDER BY tracks.popularity DESC
    LIMIT 3
) AS hiphop_top;

-- Top 10 artistas por número de álbumes y duración promedio de sus canciones

SELECT
	artists.artist_name,
	COUNT(albums.album_id) AS total_albums,
	AVG(tracks.duration_ms) AS duration_average
FROM artists
INNER JOIN tracks
	ON tracks.artist_id = artists.artist_id
INNER JOIN albums
	ON tracks.album_id = albums.album_id
GROUP BY artists.artist_id, artists.artist_name
ORDER BY total_albums DESC
LIMIT 10;

-- Número de artistas con la palabra (X) en su bibliografía

SELECT
artist_name,
biography
FROM artists
WHERE biography LIKE "%Spanish%";

-- Número de canciones con la palabra (Love) en su título agrupado por género

SELECT
genres.genre_name,
COUNT(DISTINCT tracks.track_id) AS "Total Canciones con Love"
FROM tracks
JOIN artist_genres 
	ON tracks.artist_id = artist_genres.artist_id
JOIN genres 
	ON artist_genres.genre_id = genres.genre_id
WHERE tracks.track_name LIKE '%Love%'
GROUP BY genres.genre_id, genres.genre_name
ORDER BY COUNT(DISTINCT tracks.track_id) DESC;



