<?php

    $connection = new mysqli(
		'localhost', 
		'root', 
		'4321!@#$qW', 
		'test');

    if (!$connection) {
        echo "connection failed!";
        exit();
    }
	
?>
