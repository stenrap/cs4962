<?php

// http://www.robjohansen.com/strux?code=9F8ED514-4081-4C3E-A1AC-273445D81AE9&fontName=Arial&fontSize=14

$ikeaCode = '9F8ED514-4081-4C3E-A1AC-273445D81AE9';
$rubberMaidCode = '6768A4BE-8146-4049-B426-142457287E4D';

$code     = $_GET['code'];
$fontName = $_GET['fontName'];
$fontSize = $_GET['fontSize'];

if (strcasecmp($code, $ikeaCode) === 0) {
	$title = 'IKEA Drawer';
	$steps = <<<IKE
    		<li>Remove the protective film on the back and edge of the door or drawer front before mounting/assembly:</li>
    			<img src="images/ikea1.png" class="img-responsive img-thumbnail">
    		<li>Assemble the drawer and fit the hinges:</li>
    			<img src="images/ikea2.png" class="img-responsive img-thumbnail">
    		<li>Immediately after having removed the protective film the surface is especially sensitive to scratches. You can increase the surface’s resistance to scratches by curing it:</li>
    			<img src="images/ikea3.png" class="img-responsive img-thumbnail">
    		<li>Wash it with a soft cloth, using a mild soap solution (max. 1%). Note! Do not use any cleaners containing alcohol or abrasives:</li>
    			<img src="images/ikea4.png" class="img-responsive img-thumbnail">
    		<li>Wipe clean and then let the surface harden for about 24 hours.</li>
IKE;
} else {
	$title = 'Rubbermaid Decorative Bracket';
	$steps = <<<RUB
    		<li>Select your bracket quantity, size, and style.</li>
    		<li>Select your shelf size and color.<br/><br/>For 10" deep board installations: Mount the 8" side of the 6" x 8" bracket to the board. Mount the 6" side directly to the wall.<br/><br/>For 8" deep board installations: Mount the 6" side of the 6" x 8" bracket to the board. Mount the 8" side directly to the wall:</li>
    			<img src="images/rub2.png" class="img-responsive img-thumbnail">
    		<li>Locate wall studs and mark mounting locations of the top hole of the brackets, ensuring the holes are level. You should install brackets into all possible studs along the length of your shelf for stated load capacities:</li>
    			<img src="images/rub3.png" class="img-responsive img-thumbnail">
    		<li>Partially install Screw <strong>A</strong> into marked holes at stud locations leaving a small gap for bracket adjustment.</li>
    		<li>Place the top hole of the bracket onto screw and push down to secure. Use screws <strong>A</strong> to secure the bottom of the bracket into the stud. Tighten down the top screw:</li>
    			<img src="images/rub5.png" class="img-responsive img-thumbnail">
    		<li>Rest shelf on brackets. Use screws <strong>B</strong> provided to secure the board to the brackets:</li>
    			<img src="images/rub6.png" class="img-responsive img-thumbnail">
RUB;
}

?>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
    	<title><?php echo $title; ?></title>
    	<link href="css/bootstrap.min.css" rel="stylesheet">
    	<style>
    		html, body {
    			font-family: <?php echo $fontName; ?>;
    			font-size: <?php echo $fontSize; ?>px;
    			padding: 15px;
    		}
    		h3 {
    			margin-bottom: 30px;
    		}
    		li {
    			margin-bottom: 15px;
    		}
    		.img-thumbnail {
    			margin: 20px 0 50px 0;
    		}
    	</style>
    </head>
    <body>
    	<h3><?php echo $title; ?></h3>
    	<ol>
    		<?php echo $steps; ?>
    	</ol>
    	<script src="js/jquery.min.js"></script>
    	<script src="js/bootstrap.min.js"></script>
    </body>
</html>