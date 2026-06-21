<?php
require("c:/xampp/htdocs/murg/assets/mashaAllah/gyada.php");
$_POST['specilizationid'] = 4; // assuming 4 is a valid id
$sql = mysqli_query($con, "SELECT quantity FROM stocks WHERE id='4'");
if($row=mysqli_fetch_array($sql)){
  echo "Quantity is: " . $row['quantity'];
}
?>
