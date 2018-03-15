<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <?php 
	$myfile = fopen("goodbad.txt", "r") or die("Unable to open file!");
	$goodbad = fread($myfile,filesize("goodbad.txt"));
	fclose($myfile);
	if ($goodbad > 6 ) {
		echo '<p>Hello World</p>';
	}
	else {
		echo '<p>ERROR</p>';
		#header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
	}
?>
 </body>
</html>
