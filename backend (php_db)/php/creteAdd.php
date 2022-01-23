<?php include ("conn.php"); header("Access-Control-Allow-Origin: *"); 
$base64_string = $_POST["image"]; $title = $_POST["title"]; $price = 
$_POST["price"]; $key = $_POST['key']; if ($key == 
"z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    try
    {
        $outputfile = "/var/www/html/test/uploads/" . $name . ".jpg";
        $filehandler = fopen($outputfile, 'wb');
        if (!$filehandler)
        {
            echo json_encode("-1");
        }
        else
        {
            $data = fwrite($filehandler, base64_decode($base64_string));
            fclose($filehandler);
            $query = "INSERT INTO `add`(`title`, `price`, `image`) 
VALUES ('$title','$price','$name" . ".jpg')";
            if (mysqli_query($connection, $query))
            {
                $queryResult = mysqli_query($connection, "SELECT 
MAX(`id`) FROM `add` LIMIT 1");
                $results = mysqli_fetch_array($queryResult);
                $productID = $results["id"];
                
            }
            else
            {
                echo json_encode("-1");
            }
        }
    }
    catch(Exception $e)
    {
        echo json_encode($e);
    }
}
else {
    echo "<font color=red> Access denied ! </font>";
}
?>
