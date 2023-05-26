
DROP TABLE IF EXISTS movies;

-- movieid = movie idenifier
-- title = movie title
-- releasedate = date that movie was released
-- url = url of movie information
-- there are 19 movie genres (unknown, action, ..., western)
-- a movie belongs to genre X iff it has a value of 1 for column X
-- a movie can belong to multiple genres
CREATE TABLE movies (
movieid INTEGER PRIMARY KEY, 
title TEXT,
releasedate DATE,
url TEXT,
unknown INTEGER,
action INTEGER,
adventure INTEGER,
animation INTEGER,
children INTEGER,
comedy INTEGER,
crime INTEGER,
documentary INTEGER,
drama INTEGER,
fantasy INTEGER,
filmnoir INTEGER,
horror INTEGER,
musical INTEGER,
mystery INTEGER,
romance INTEGER,
scifi INTEGER,
thriller INTEGER,
war INTEGER,
western INTEGER
);


-- load table
\copy movies FROM '~/lru_project/testdata/movies.txt' DELIMITER '|';

