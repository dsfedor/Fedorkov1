<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html">    
</head>
<body>

<textarea rows='50' cols='200'>
<?php
require 'connect.php'; // inqlude file with connection string
$mysqli->set_charset("utf8");
$address = trim($_REQUEST['TXTaddress']); // get content "address" field and cut possible spaces at string start
$sql_select = "SELECT message.int_id, message.created, message.str FROM message JOIN log USING (int_id) WHERE log.address = '{$address}' UNION SELECT int_id, created, str FROM  log WHERE address = '{$address}' ORDER BY int_id, created"; 

$res = $mysqli -> query($sql_select);  // run query
 
$n=0;

while ($row = $res -> fetch_assoc()) {
           $n++;
           if ($n == 101) {		
           echo "\n"."MORE THAN 100 ROWS WERE FOUND!";
	   break;
	   }          
      echo $row['created']." ".$row['str']."\n";
}
$mysqli->close();
?>
</textarea>
</form>
<form method="post" action="index.html">
<input id="submitback" type="submit" value="GO BACK">
</form>
</body>
</html>



