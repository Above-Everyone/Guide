<?php

include_once("market_profiles.php");


$ip = $_SERVER["HTTP_CF_CONNECTING_IP"] ?? "" ;
$agent = str_replace(" ", "_", ($_SERVER["HTTP_USER_AGENT"] ?? ""));
$agent = str_replace(";", "-", $agent);

$ym_user = $_GET['user'] ?? "";
$ym_pw = $_GET['pass'] ?? "";

$auth = Profiles::auth($ym_user, $ym_pw, $ip);

if($auth->username != "")
{
    setcookie("ym_user_info", $auth->retrieve_info(), time() + (86400 * 30), "/");
}

var_dump($_COOKIE);
?>