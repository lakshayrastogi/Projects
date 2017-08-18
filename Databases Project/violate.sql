-- violates primary key constraint by providing duplicate id for Movie
INSERT INTO Movie(id, title, year, rating, company)
VALUES (2, 'random', '2015', 'G', 'Disney'); 
-- violates primary key constraint by providing duplicate id for Actor
INSERT INTO Actor(id, last, first, sex, dob, dod)
VALUES (1, 'last', 'first', 'Female', '1975-05-25', NULL); 

-- violates primary key constraint by providing duplicate id for Director
INSERT INTO Director(id, last, first, dob, dod)
VALUES (16, 'l', 'f', '1960-07-15', NULL); 

-- violates foreign key mid must reference a valid id
INSERT INTO MovieGenre(mid, genre)
VALUES (0, 'Drama');

--violate foreign key mid must reference a valid id
INSERT INTO MovieDirector(mid, did)
VALUES (0, 112);

--violates foreign key did must reference a valid id
INSERT INTO MovieDirector(mid, did)
VALUES (3, 0);

-- violates foreign key mid must reference a valid id
INSERT INTO MovieActor(mid, aid, role)
VALUES (0, 162, 'Lead Role');

-- violates foreign key aid must reference a valid id 
INSERT INTO MovieActor(mid, aid, role)
VALUES (2, 0, 'Lead Role');

--violates foreign key mid must reference a valid id
INSERT INTO Review(name, time, mid, rating, comment)
VALUES( 'name', 1390791195, 0, 2, 'good');

-- would violate check if they worked in mysql
-- movie title must not be an empty string
INSERT INTO Movie(id, title, year, rating, company)
VALUES (1, '', '2015', 'G', 'Disney'); 

-- would violate check if they worked in mysql
-- actor fist name must not be empty
INSERT INTO Actor(id, last, first, sex, dob, dod)
VALUES (2, 'last', '', 'Female', '1975-05-25', NULL); 

-- would violate check if they worked in mysql
-- actor last name must not be empty 
INSERT INTO Actor(id, last, first, sex, dob, dod)
VALUES (2, '', 'first', 'Female', '1975-05-25', NULL); 

 
