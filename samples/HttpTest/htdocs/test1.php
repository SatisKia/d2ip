<?php

$user = '';

if( isset( $_GET['user'] ) )
{
	$user = $_GET['user'];
}

$score = 0;
if( $user === 'guest' )
{
	$score = 12345;
}

header( 'Content-Type: text/plain' );
echo 'user=' . urlencode( $user );
echo '&score=' . $score;

?>
