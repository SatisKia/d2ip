<?php

$user = '';

if( isset( $_POST['user'] ) )
{
	$user = $_POST['user'];
}

$score = 0;
if( $user === 'guest' )
{
	$score = 6789;
}

header( 'Content-Type: text/plain' );
echo 'user=' . urlencode( $user );
echo '&score=' . $score;

?>
