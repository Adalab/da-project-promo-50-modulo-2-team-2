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
    type_albums VARCHAR(100),
    popularity FLOAT
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

SELECT COUNT(*) FROM artists;

SELECT * FROM tracks LIMIT 5;

SELECT * FROM genre_albums LIMIT 5;