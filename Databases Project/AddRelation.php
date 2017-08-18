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
                    <li>
                        <a href="AddInfo.php">Add Actor/Director/Movie Info</a>
                    </li>
                    <li class="active">
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

    <?php
        $db_connection = mysqli_connect("localhost", "cs143", "", "CS143");
            if(!db_connection) {
                echo "Couldn't connect to database";
                exit;
            }
            // if(!mysql_select_db(CS143)){
            //     echo "Couldn't select database";
            // }
        function mysql_fetch_all($query) {
            $result = mysql_query($query);
            $rows = array();
            while($row = mysql_fetch_assoc($result)) {
              $rows[] = $row;
            }
            mysql_free_result($result);
            return $rows;
        }

        function select_list_generate($name, $value, $valuefield, $displayfield) {
            $selectList = '<select name="' . $name . '">';
            foreach ( $value as $singlevalue ) {
                $selectList .= '<option value="' . $singlevalue[$valuefield] . '">' . $singlevalue[$displayfield] . '</option>';
            }
            $selectList .= '</select>';
            return $selectList;
        }

        $actor_query = 'SELECT Actor.id, CONCAT(Actor.first, " ", Actor.last, " (", dob, ")") as Name FROM Actor ORDER BY Actor.first, Actor.last';
        $movie_query = 'SELECT CONCAT(title, " (", year, ")") as title, id FROM Movie ORDER BY title';
        $director_query = 'SELECT Director.id, CONCAT(Director.first, " ", Director.last, " (", dob, ")") as Name FROM Director ORDER BY Director.first, Director.last';

        $actor_result = mysqli_query($db_connection, $actor_query);
        $movie_result = mysqli_query($db_connection, $movie_query);
        $director_result = mysqli_query($db_connection, $director_query);
        // $actor_data = mysql_fetch_all($actor_query);
        // $movie_data = mysql_fetch_all($movie_query);
        // $director_data = mysql_fetch_all($director_query);

        // mysql_close($db_connection);
    ?>

    <div class="container">
        <br><br><br><br><br><br><br>
        <div class="row">
            <div class="col-lg-3 col-lg-offset-2">
                <br>
                <h2>Would you like to add an actor/movie relation?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <!--<?php echo select_list_generate('actor', $actor_data, "id", "Name"); ?><br>
                    <?php echo select_list_generate('movie', $movie_data, "id", "title"); ?><br><br>-->
                    <?php
                        print "<select class='form-control' name = 'movie'>";
                        print "<option value=''>Select Movie</option>";
                        while ($row = mysqli_fetch_assoc($movie_result))
                            print '<option value="' . $row["id"] . '">' . $row["title"] . '</option>';
                        print "</select>";
                        print "<br>";
                        mysqli_free_result($movie_result);

                        print "<select class='form-control' name = 'actor'>";
                        print "<option value=''>Select Actor</option>";
                        while ($row = mysqli_fetch_assoc($actor_result))
                            print '<option value="' . $row["id"] . '">' . $row["Name"] . '</option>';
                        print "</select>";
                        print "<br>";
                        mysqli_free_result($actor_result);
                    ?>
                    <div class="form-group">
                      <input type="text" name="role" class="form-control" placeholder="Role of Actor" maxlength=50 style="width: 250px; margin: 0 auto;">
                    </div>
                    <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
            <div class="col-lg-3 col-lg-offset-2">
                <br>
                <h2>Would you like to add a director/movie relation?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <!--<?php echo select_list_generate('director', $director_data, "id", "Name"); ?><br>
                    <?php echo select_list_generate('movie', $movie_data, "id", "title"); ?><br><br>-->
                    <?php
                        $movie_result = mysqli_query($db_connection, $movie_query);
                        print "<select class='form-control' name = 'movie'>";
                        print "<option value=''>Select Movie</option>";
                        while ($row = mysqli_fetch_assoc($movie_result))
                            print '<option value="' . $row["id"] . '">' . $row["title"] . '</option>';
                        print "</select>";
                        print "<br>";
                        mysqli_free_result($movie_result);

                        print "<select class='form-control' name = 'director'>";
                        print "<option value=''>Select Director</option>";
                        while ($row = mysqli_fetch_assoc($director_result))
                            print '<option value="' . $row["id"] . '">' . $row["Name"] . '</option>';
                        print "</select>";
                        print "<br>";
                        mysqli_free_result($director_result);

                        mysqli_close($db_connection);
                    ?>
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
        if(!empty($_GET['actor']) && !empty($_GET['movie'])) {
            //execute query after connecting to database
            $db_connection = mysql_connect("localhost", "cs143", "");
            if(!db_connection) {
                echo "Couldn't connect to database";
                exit;
            }
            if(!mysql_select_db(CS143)){
                echo "Couldn't select database";
            }
            $actor = $_GET['actor'];
            $movie = $_GET['movie'];
            $role = $_GET['role'];
            
            $query = "INSERT INTO MovieActor VALUES ('$movie', '$actor', '$roll')";
            $query_results = mysql_query($query);
            if (mysql_error() != '') {
                echo "An error occured with your query";
            }
            else 
                print '<h1>Added!</h1>';
            mysql_free_result($query_results);
            mysql_close($db_connection);
        }
        if (!empty($_GET['movie']) && !empty($_GET['director'])) {
            //execute query after connecting to database
            $db_connection = mysql_connect("localhost", "cs143", "");
            if(!db_connection) {
                echo "Couldn't connect to database";
                exit;
            }
            if(!mysql_select_db(CS143)){
                echo "Couldn't select database";
            }
            $director = $_GET['director'];
            $movie = $_GET['movie'];
            
            $query = "INSERT INTO MovieDirector VALUES('$movie', '$director')";
            $query_results = mysql_query($query);
            if (mysql_error() != '') {
                echo "An error occured with your query insert Movie";
            }
            else 
                print '<h1>Added!</h1>';
            mysql_free_result($query_results);
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
