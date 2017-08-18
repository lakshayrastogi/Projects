CREATE TABLE Movie(id INT NOT NULL, title VARCHAR(100) NOT NULL, 
		   year INT NOT NULL, rating VARCHAR(10), 
		   company VARCHAR(50), PRIMARY KEY (id),
		   CHECK(LENGTH(title) > 0)) ENGINE =INNODB;

CREATE TABLE Actor(id INT NOT NULL, last VARCHAR(20), 
		   first VARCHAR(20), sex VARCHAR(6), 
		   dob DATE NOT NULL, dod DATE, 
		   PRIMARY KEY (id), CHECK(dob < dod),
		   CHECK(LENGTH(last)>0), CHECK(LENGHT(first)>0))
		   ENGINE INNODB;

CREATE TABLE Director(id INT NOT NULL, last VARCHAR(20), 
		      first VARCHAR(20), dob DATE NOT NULL, 
		      dod DATE, PRIMARY KEY (id),
		      CHECK(dob < dod), CHECK(LENGTH(last)>0), 
		      CHECK(LENGHT(first)>0)) ENGINE INNODB;

CREATE TABLE MovieGenre( mid INT NOT NULL, genre VARCHAR(20) NOT NULL,
			 FOREIGN KEY (mid) REFERENCES Movie(id)) ENGINE INNODB;

CREATE TABLE MovieDirector(mid INT NOT NULL, did INT NOT NULL,
			   FOREIGN KEY (mid) REFERENCES Movie(id),
			   FOREIGN KEY (did) REFERENCES Director(id),
			   UNIQUE(mid, did)) ENGINE INNODB; 

CREATE TABLE MovieActor(mid INT NOT NULL, aid INT NOT NULL, 
			role VARCHAR(50), 
			FOREIGN KEY (mid) REFERENCES Movie(id), 
			FOREIGN KEY (aid) REFERENCES Actor(id),
			UNIQUE(mid,aid,role)) ENGINE INNODB;

CREATE TABLE Review(name VARCHAR(20), time TIMESTAMP, 
		    mid INT NOT NULL, rating INT NOT NULL,
		    comment VARCHAR(500), 
		    FOREIGN KEY (mid) REFERENCES Movie(id),
		    UNIQUE(name,mid), CHECK(rating >= 0 AND rating <= 10))
		    ENGINE INNODB;

CREATE TABLE MaxPersonID(id INT NOT NULL) ENGINE INNODB;

CREATE TABLE MaxMovieID(id INT NOT NULL) ENGINE INNODB;
