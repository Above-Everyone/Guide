<?php


include_once("yomarket.php");

//$ym = new YoMarket();
//$logs = $ym->price_logs();

//var_dump($logs);

$p = "26295";
$t = "https://yw-web.yoworld.com/cdn/items/". substr($p, 0, 2). "/". substr($p, 2, 2). "/". $p. "/". $p. "_60_60.gif";

echo $t;
?>
