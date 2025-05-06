CREATE DATABASE musicstream;

USE musicstream;

CREATE TABLE IF NOT EXISTS artists (
    artist_id VARCHAR(250) PRIMARY KEY,
    artist_name VARCHAR(250),
    listeners BIGINT,
    reproductions BIGINT,
    biography TEXT
);

CREATE TABLE IF NOT EXISTS albums (
    album_id VARCHAR(250) PRIMARY KEY,
    album_name VARCHAR(250),
    release_date DATE,
    total_tracks INT,
    type_albums VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS tracks (
    track_id VARCHAR(250) PRIMARY KEY,
    track_name VARCHAR(250),
    artist_id VARCHAR(250),
    album_id VARCHAR(250),
    duration_ms FLOAT,
    popularity FLOAT,
    release_date DATE,
    type_tracks VARCHAR(200),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(250)
);

CREATE TABLE IF NOT EXISTS artist_genres (
    artist_id VARCHAR(300),
    genre_id INT,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS genre_albums (
	album_id VARCHAR(300),
    genre_id INT,
    PRIMARY KEY (album_id, genre_id),
	FOREIGN KEY (album_id) REFERENCES albums(album_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS market (
	market_id VARCHAR(250) PRIMARY KEY,
    market_name VARCHAR (250)
);

CREATE TABLE IF NOT EXISTS market_track (
	market_id VARCHAR(300),
    track_id VARCHAR(300),
    PRIMARY KEY (market_id, track_id),
	FOREIGN KEY (market_id) REFERENCES market(market_id),
    FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);

CREATE TABLE IF NOT EXISTS market_album (
	market_id VARCHAR(300),
    album_id VARCHAR(300),
    PRIMARY KEY (market_id, album_id),
	FOREIGN KEY (market_id) REFERENCES market(market_id),
    FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

CREATE TABLE IF NOT EXISTS similar_artists (
	artist_id VARCHAR(250) PRIMARY KEY, 
    similar_artirst_name TEXT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

ALTER TABLE albums MODIFY COLUMN release_date DATE;

ALTER TABLE tracks MODIFY COLUMN release_date DATE;

-- Verificar si hay datos
SELECT COUNT(*) FROM artists;
SELECT COUNT(*) FROM albums;
SELECT COUNT(*) FROM tracks;
SELECT COUNT(*) FROM market;

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
LIMIT 4;

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
    WHERE genres.genre_name = 'indie'
    ORDER BY tracks.popularity DESC
    LIMIT 3
) AS indie
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

-- Número de artistas con la palabra 'Spanish' en su bibliografía
SELECT
artist_name,
biography
FROM artists
WHERE biography LIKE "%Spanish%";

-- Número de canciones con la palabra 'Love' en su título agrupado por género
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

-- Consultar canciones del 2012 :
SELECT
track_name, release_date
FROM tracks
WHERE YEAR(release_date) = 2012;

-- Canciones más populares del artista 'Skrillex':
SELECT
	artists.artist_name,
    tracks.track_name,
	tracks.popularity
FROM artists
INNER JOIN tracks
	ON artists.artist_id = tracks.artist_id
WHERE artists.artist_name LIKE '%skrillex%'
ORDER BY popularity DESC
LIMIT 1;
SELECT
tracks.track_name,  tracks.popularity
FROM tracks
INNER JOIN artists
ON  tracks.artist_id = artists.artist_id
WHERE artists.artist_name LIKE '%skrillex%';

-- Sacar las canciones que duren más o menos de un tiempo que consideremos (más de dos minutos)
SELECT
tracks.track_name, tracks.duration_ms
FROM tracks
INNER JOIN artists
ON tracks.artist_id = artists.artist_id
WHERE artists.artist_name = 'Rocko' AND tracks.duration_ms > 120000;

-- ¿Qué género es el más escuchado en España (pop/indie/rock/hip-hop)?
SELECT
genres.genre_name,
SUM(artists.listeners) AS total_listeners
FROM tracks
INNER JOIN market_track
ON tracks.track_id = market_track.track_id
INNER JOIN albums
ON tracks.album_id = albums.album_id
INNER JOIN genre_albums
ON albums.album_id = genre_albums.album_id
INNER JOIN genres
ON genre_albums.genre_id = genres.genre_id
INNER JOIN artists
ON tracks.artist_id = artists.artist_id
WHERE market_track.market_id = 'ES' AND genres.genre_name IN ('pop', 'indie', 'rock', 'hip-hop')
GROUP BY genres.genre_name
ORDER BY total_listeners ASC
LIMIT 1;

-- ¿Qué género tiene más canciones?
SELECT
genres.genre_name,
COUNT(tracks.track_id) AS total_canciones_genero
FROM tracks
INNER JOIN albums ON tracks.album_id = albums.album_id
INNER JOIN genre_albums ON albums.album_id = genre_albums.album_id
INNER JOIN genres ON genre_albums.genre_id = genres.genre_id
GROUP BY genres.genre_name
ORDER BY COUNT(tracks.track_id) ASC;
