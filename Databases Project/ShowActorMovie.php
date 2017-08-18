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
                    <li>
                        <a href="AddRelation.php">Add Movie/Director/Actor Relation</a>
                    </li>
                    <li>
                        <a href="Search.php">Search</a>
                    </li>
                    <li class="active">
                        <a href="ShowActorMovie.php">Show Movie/Actor Info</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <br><br><br><br><br>
                <h1>Would you like to find an Actor or Movie</h1>
                <h4>Try searching through our database</h4>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-3 col-lg-offset-2">
                <br><br>
                <h2>Would you like to search an actor?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <div class="form-group">
                      <input type="text" name="query" class="form-control">
                    </div>
                    <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
            <div class="col-lg-3 col-lg-offset-2">
                <br><br>
                <h2>Would you like to search a movie?</h2>
                <br>
                <form role="form" action="#" method="GET">
                    <div class="form-group">
                      <input type="text" name="query2" class="form-control">
                    </div>
                    <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
        </div>
    </div>

    <?php
      print '<div class="row">';
      print '<div class="col-lg-4 col-lg-offset-4">';
    	if(! empty( $_GET['query'])) {
    		//execute query after connecting to database
    		$db_connection = mysql_connect("localhost", "cs143", "");
    		if(!db_connection) {
    			echo "Couldn't connect to database";
    			exit;
    		}
    		if(!mysql_select_db(CS143)){
    			echo "Couldn't select database";
    		}
            $Q1 = $_GET['query'];
            $keywords = explode(' ', strtolower($Q1));
            $actor_sql = 'SELECT Actor.id, CONCAT(Actor.first, " ", Actor.last, " (", dob, ")") as Name FROM Actor WHERE true';

            foreach ( $keywords as $term ) {
                $actor_sql .= ' AND ( LOWER(Actor.first) LIKE "%' . $term . '%" OR LOWER(Actor.last) LIKE "%' . $term . '%" )';
            }

            $query_results = mysql_query( $actor_sql);

    		if (mysql_error() != '') {
    			echo "An error occured with your query";
    		}
    		if (mysql_num_rows($query_results) == 0) {
    			echo "No results found from query.";
    		}
    		else {
          print '<br>';
    			print '<table class="table table-responsive text-center">';
          print '<thead>';
          print '<tr>';
    			$i=0;
    			while($i < mysql_num_fields($query_results)){
    				$attr= mysql_fetch_field($query_results, $i);
    				print '<th>' . $attr->name . '</th>';
    				$i++;
    			}
          print '</thead>';
          print '</tr>';
          print '<tbody>';
    			while($row = mysql_fetch_assoc($query_results)){
    				print '<tr>';
    				foreach ($row as $item){
    					if (!$item) {
    						print '<td>N/A</td>';
    					}
    					else {
    						print '<td>' . $item . '</td>';
    					}
    				}
    				print '</tr>';
    			}
          print '</tbody>';
    			print '</table>';
    		}
    		mysql_free_result($query_results);
    		mysql_close($db_connection);
        }
      if(! empty( $_GET['query2'])) {
    		//execute query after connecting to database
    		$db_connection = mysql_connect("localhost", "cs143", "");
    		if(!db_connection) {
    			echo "Couldn't connect to database";
    			exit;
    		}
    		if(!mysql_select_db(CS143)){
    			echo "Couldn't select database";
    		}
    		$Q1 = $_GET['query2'];
            $keywords = explode(' ', strtolower($Q1));
            $movie_sql = 'SELECT Movie.id, CONCAT(Movie.title, " (", year, ")") as title FROM Movie WHERE true';
            foreach ( $keywords as $term ) {
                $movie_sql .= ' AND LOWER(Movie.title) LIKE "%' . $term . '%"';
            }
    		$query_results = mysql_query( $movie_sql);

    		if (mysql_error() != '') {
    			echo "An error occured with your query";
    		}
    		if (mysql_num_rows($query_results) == 0) {
    			echo "No results found from query.";
    		}
    		else {
          print '<br>';
    			print '<table class="table table-responsive text-center">';
          print '<thead>';
          print '<tr>';
    			$i=0;
    			while($i < mysql_num_fields($query_results)){
    				$attr= mysql_fetch_field($query_results, $i);
    				print '<th>' . $attr->name . '</th>';
    				$i++;
    			}
          print '</thead>';
          print '</tr>';
          print '<tbody>';
    			while($row = mysql_fetch_assoc($query_results)){
    				print '<tr>';
    				foreach ($row as $item){
    					if (!$item) {
    						print '<td>N/A</td>';
    					}
    					else {
    						print '<td>' . $item . '</td>';
    					}
    				}
    				print '</tr>';
    			}
          print '</tbody>';
    			print '</table>';
    		}
    		mysql_free_result($query_results);
    		mysql_close($db_connection);
    	}
      print '</div>';
      print '</div>'
    ?>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
