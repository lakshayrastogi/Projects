<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>IMDb CLONE</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main {
            background-color: #17a88c;
            color: #fff;
            text-align: center;
        };
    </style>
  </head>
  <body class="main">
    
    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="index.php">IMDb Clone</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li class="active">
                        <a href="AddInfo.php">Add Actor/Director/Movie Info</a>
                    </li>
                    <li>
                        <a href="AddRelation.php">Add Movie/Director/Actor Relation</a>
                    </li>
                    <li>
                        <a href="Search.php">Search</a>
                    </li>
                    <li>
                        <a href="ShowActorMovie.php">Show Movie/Actor Info</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <div class="container">
        <br><br><br><br>
        <div class="row">
            <div class="col-lg-3 col-lg-offset-2">
                <br>
                <h2>Would you like to add an actor/director?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <label class="radio-inline">
                        <input type="radio" name="ad" value="Actor" checked>Actor
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="ad" value="Director">Director
                    </label>
                    <br> <br>
                    <div class="form-group">
                      <input type="text" name="firstname" class="form-control" placeholder="First Name" maxlength=20 required>
                    </div>
                    <div class="form-group">
                      <input type="text" name="lastname" class="form-control" placeholder="Last Name" maxlength=20>
                    </div>
                    <label class="radio-inline">
                        <input type="radio" name="sex" value="Male" checked>Male
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="sex" value="Female">Female
                    </label>
                    <br> <br>
                    <div class="form-group">
                      <input type="date" name="dob" class="form-control" placeholder="Date of Birth (YYYY-MM-DD)" required>
                    </div>
                    <div class="form-group">
                      <input type="date" name="dod" class="form-control" placeholder="Date of Death (YYYY-MM-DD)">
                    </div>
                    <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
            <div class="col-lg-3 col-lg-offset-2">
                <br>
                <h2>Would you like to add a movie?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <div class="form-group">
                      <input type="text" name="movietitle" class="form-control" placeholder="Title" maxlength=100 required>
                    </div>
                    <div class="form-group">
                      <input type="text" name="company" class="form-control" placeholder="Company/Studio" maxlength=50>
                    </div>
                    <div class="form-group">
                      <input type="text" name="year" class="form-control" placeholder="Year" maxlength=4 required>
                    </div>
                    <select class="form-control" name="rating">
                        <option value="">Select MPAA Rating</option>
                        <option value="G">G</option>
                        <option value="NC-17">NC-17</option>
                        <option value="PG">PG</option>
                        <option value="PG-13">PG-13</option>
                        <option value="R">R</option>
                        <option value="surrendere">surrendere</option>
                    </select>
                    <br>
                    <label>Genre(s):</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Action">Action</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Adult">Adult</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Adventure">Adventure</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Animation">Animation</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Comedy">Comedy</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Crime">Crime</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Documentary">Documentary</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Drama">Drama</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Family">Family</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Fantasy">Fantasy</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Horror">Horror</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Musical">Musical</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Mystery">Mystery</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Romance">Romance</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Sci-Fi">Sci-Fi</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Short">Short</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Thriller">Thriller</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="War">War</label>
                    <label class="checkbox-inline"><input type="checkbox" name="genre[]" id="genre" value="Western">Western</label>
                    <br> <br>
                    <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                    <br>
                    <br>
                </form>
            </div>
        </div>
    </div>

    <?php
      print '<div class="row">';
      print '<div class="col-lg-4 col-lg-offset-4">';
        if(!empty($_GET['firstname'])) {
            //execute query after connecting to database
            $db_connection = mysql_connect("localhost", "cs143", "");
            if(!db_connection) {
                echo "Couldn't connect to database";
                exit;
            }
            if(!mysql_select_db(CS143)){
                echo "Couldn't select database";
            }
            $ad = $_GET['ad'];
            $firstname = $_GET['firstname'];
            $lastname = $_GET['lastname'];
            $sex = $_GET['sex'];
            $dob = $_GET['dob'];
            $dod = $_GET['dod'];
            // print "<p> $ad $firstname $lastname $sex $dob $dod </p>";
            if ($dod == "")
                $dod = NULL;
            $pattern = '/^(18|19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$/';
            if (preg_match($pattern, $dob) && (preg_match($pattern, $dod) || $dod == NULL)) {
                $query = 'SELECT id FROM MaxPersonID';
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                    echo "An error occured with your query";
                }
                $row = mysql_fetch_assoc($query_results);
                $id = $row["id"];
                $id += 1;
                mysql_free_result($query_results);
                $query = "UPDATE MaxPersonID SET id = $id";
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                     echo "An error occured with your query";
                }
                mysql_free_result($query_results);
            
                if ($ad == "Actor")
                    $query = "INSERT INTO $ad VALUES ('$id', '$lastname', '$firstname', '$sex', '$dob', '$dod')";
                else
                    $query = "INSERT INTO $ad VALUES ('$id', '$lastname', '$firstname', '$dob', '$dod')";
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                    echo "An error occured with your query";
                }
                else 
                    print '<h1>Added!</h1>';
                mysql_free_result($query_results);
            }
            else print "<h1>Invalid Date of Birth or Date of Death. Please input in specified format.</h1>";
            mysql_close($db_connection);
        }
        if (!empty($_GET['movietitle'])) {
            //execute query after connecting to database
            $db_connection = mysql_connect("localhost", "cs143", "");
            if(!db_connection) {
                echo "Couldn't connect to database";
                exit;
            }
            if(!mysql_select_db(CS143)){
                echo "Couldn't select database";
            }
            $title = $_GET['movietitle'];
            $company = $_GET['company'];
            $year = $_GET['year'];
            $rating = $_GET['rating'];
            $genre = $_GET['genre'];

            if (!empty($year) && ($year < 2015 && $year > 1800)) {
                //print_r($_GET['genre']);
                $query = 'SELECT id FROM MaxMovieID';
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                    echo "An error occured with your query retrieve MaxMovieID";
                }
                $row = mysql_fetch_assoc($query_results);
                $id = $row["id"];
                $id += 1;
                mysql_free_result($query_results);
                $query = "UPDATE MaxMovieID SET id = $id";
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                     echo "An error occured with your query update MaxMovieID";
                }
                mysql_free_result($query_results);
                $query = "INSERT INTO Movie VALUES('$id', '$title', '$year', '$rating', '$company')";
                $query_results = mysql_query($query);
                if (mysql_error() != '') {
                    echo "An error occured with your query insert Movie";
                }
                else 
                    print '<h1>Added!</h1>';
                mysql_free_result($query_results);
                foreach ($genre as $singlegenre)
                {
                    $query = "INSERT INTO MovieGenre VALUES('$id', '$singlegenre')";
                    $query_results = mysql_query($query);
                    if (mysql_error() != '') {
                        echo "An error occured with your query's genres";
                    }
                    mysql_free_result($query_results);
                }
            }
            else print "<h1>Please provide valid year.</h1>";
            mysql_close($db_connection);
        }
      print '</div>';
      print '</div>';
    ?>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
