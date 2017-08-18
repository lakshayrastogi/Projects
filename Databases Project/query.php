<!DOCTYPE html>
<head>
	<title>Movie Database Query Engine</title>
</head>
<body>
	<h1>Welcome to the Movie Database Query Engine!</h1>
	<p>Project by Akhil Nadendla and Lakshay Rastogi</p>
	<p>Type a MySql query in the following box:</p>
	<p> 
		<form action="#" method="GET">
			<textarea name="query" cols="70" rows="4">
			</textarea>
			</br>
			<input type="submit" value="Submit"/>
		</form>
	</p>

<?php
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
		$query_results = mysql_query( $Q1);
		if (mysql_error() != '') {
			echo "An error occured with your query";
		}
		if (mysql_num_rows($query_results) == 0) {
			echo "No results found from query.";
		}
		else {
			print '<table border="2">';
			$i=0;
			while($i < mysql_num_fields($query_results)){
				$attr= mysql_fetch_field($query_results, $i);
				print '<th>' . $attr->name . '</th>';
				$i++;
			}
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
			print '</table>';
		}	
		
		mysql_free_result($query_results);
		mysql_close($db_connection);
	}
?>
</body>
</html>
