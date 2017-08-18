-- display first/last names of actors who were in die another day
SELECT CONCAT(Actor.first,' ',Actor.last)
FROM Actor, Movie, MovieActor
WHERE Movie.title='Die Another Day' AND Movie.id=MovieActor.mid 
AND MovieActor.aid=Actor.id;

-- count all actors who were in multiple movies
SELECT COUNT(DISTINCT m1.aid)
FROM MovieActor m1, MovieActor m2
WHERE m1.mid<>m2.mid AND m1.aid=m2.aid;

-- Johnny Depp's Filmography
SELECT Movie.title
FROM Actor, Movie, MovieActor
WHERE Actor.first='Johnny' AND Actor.last="Depp" AND
Movie.id=MovieActor.mid AND MovieActor.aid=Actor.id;


