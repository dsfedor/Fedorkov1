<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html">    
</head>
<body>

<textarea rows='50' cols='200'>
<?php
require 'connect.php'; // inqlude file with connection string
mysql_set_charset('utf8'); // sets the client encoding
$address = trim($_REQUEST['TXTaddress']); // get content "address" field and cut possible spaces at string start
$sql_select = "SELECT message.int_id, message.created, message.str FROM message JOIN log USING (int_id) WHERE log.address = '{$address}' UNION SELECT int_id, created, str FROM  log WHERE address = '{$address}' ORDER BY int_id, created"; 
$result = mysql_query($sql_select); // run query
$row = mysql_fetch_array($result); // getting answer from DB
$n=0;
do
{
       $n++;   
       echo
       $row['created']." ".$row['str']."\n";          
          if ($n == 100) {		
          echo "\n"."MORE THAN 100 ROWS WERE FOUND!";
	  break;
	  }
             
       
}
while($row = mysql_fetch_array($result));
?>
</textarea>
</form>
<form method="post" action="index.html">
<input id="submitback" type="submit" value="GO BACK">
</form>
</body>
</html>



