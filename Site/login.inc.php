<?php
    include_once("market_profiles.php");
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $ym_user = $_POST['ym_username'] ?? "";
    $ym_passwd = $_POST['ym_password'] ?? "";

    if(array_key_exists("ym_login", $_POST))
    {
        $auth = Profiles::auth($ym_user, $ym_passwd, "");
        setcookie("ym_user_info", $auth->retrieve_info(), time() + (600 * 30), "/", null, false, true);
        header('Location: https://yomarket.info/admin_index.php', true, 302);
        exit();
    } else {
        header('Location: https://yomarket.info/', true, 302);
        exit();
    }
?>