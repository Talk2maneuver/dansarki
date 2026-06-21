<?php
require("c:/xampp/htdocs/murg/assets/mashaAllah/gyada.php");
$sql = mysqli_query($con, "SELECT name, SUM(quantity) as total_qty, COUNT(*) as c FROM stocks GROUP BY name HAVING c > 1");
while($row = mysqli_fetch_assoc($sql)) {
  print_r($row);
}
?>
