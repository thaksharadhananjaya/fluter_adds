<?php include ("conn.php"); 
header("Access-Control-Allow-Origin: *");
 $id = mysqli_real_escape_string($connection, $_POST['id']); 
$key = mysqli_real_escape_string($connection,$_POST['key']); 
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "DELETE FROM `add` WHERE `id` = '$id'";
    mysqli_query($connection, $query);
    
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>
