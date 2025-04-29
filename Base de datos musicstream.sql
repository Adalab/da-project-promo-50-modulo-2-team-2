CREATE DATABASE musicstream;

USE musicstream;

CREATE TABLE IF NOT EXISTS artists (
    artist_id VARCHAR(500) PRIMARY KEY,
    artist_name VARCHAR(500) NOT NULL,
    listeners INT,
    reproductions INT,
    biography TEXT
);

CREATE TABLE IF NOT EXISTS albums (
    album_id VARCHAR(500) PRIMARY KEY,
    album_name VARCHAR(100) NOT NULL,
    release_date DATE,
    total_tracks INT,
    type_albums VARCHAR(20),
    popularity INT
);

CREATE TABLE IF NOT EXISTS tracks (
    track_id VARCHAR(500) PRIMARY KEY,
    track_name VARCHAR(500) NOT NULL,
    artist_id VARCHAR(500),
    album_id VARCHAR(500),
    duration_ms INT,
    popularity INT,
    release_date DATE,
    type_tracks VARCHAR(20),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id VARCHAR(500) PRIMARY KEY,
    genre_name VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS artist_genres (
    artist_id VARCHAR(300),
    genre_id INT AUTO_INCREMENT,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS genre_albums (
	album_id VARCHAR(300),
    genre_id VARCHAR(300),
    PRIMARY KEY (album_id, genre_id),
	FOREIGN KEY (album_id) REFERENCES albums(album_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS market (
	market_id VARCHAR(500) PRIMARY KEY,
    market_name VARCHAR (500)
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
	artist_id VARCHAR(500) PRIMARY KEY, 
    similar_artirst_name TEXT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

SELECT * FROM artists;

SELECT * FROM artist_genres