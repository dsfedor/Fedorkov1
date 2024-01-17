<?php

$mysqli = new mysqli("procfile1", "procfile", "12345", "procfile");  //host, login, pw, DB

if ($mysqli -> connect_error) {
  printf("Error with connect: %s\n", $mysqli -> connect_error);
  exit();
};

?>