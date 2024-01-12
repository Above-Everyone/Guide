<head>
    <meta charset="utf-8">
    <meta name="description" content="The Official #1 Price Guide For Yoworld Items. Helping the yoworld community prevent scams!">
    <meta name="author" content="YoMarket Team">
    <title>YoMarket | Home</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Roboto:wght@500;700&display=swap" rel="stylesheet"> 
    
    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>
<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include("main.php");

$eng = new YoMarket();
$r = $eng->searchItem("cupids bow", "");

if($r->type == ResponseType::NONE)
    die("[ x ] Unable to find items!");

if($r->type == ResponseType::EXACT)
{
    echo $r->result->name. " | ". $r->result->id. " | ". $r->result->price. " | ". $r->result->price;
}
else if($r->type == ResponseType::EXTRA)
{
    echo '<div class="result_box">';
    echo '<div class="grid-container">';
    foreach($r->result as $item)
    {
        echo '<div class="grid-item">';
        echo '<p class="item-name" style="font-size: 15px; color: #ff0000">'. $item->name. '</p>';
        echo '<img style="padding-top: 20px;" width="100" height="100" src="'. $item->url. '" />';
        echo '<p style="font-size: 15px;color: #ff0000">#'. $item->id. '</p>';
        echo '<p style="font-size: 15px;color: #ff0000">Price: '. $item->price. '</p>';
        echo '<p style="font-size: 15px;color: #ff0000">Last Update: '. $item->update. '</p>';
        echo '</div>';
    }
    echo '</div>';
    echo '</div>';
    // foreach($r->result as $itm)
    // {
    //     if($itm->name != NULL && $itm->name != "") echo $itm->name. " | ". $itm->id. " | ". $itm->price. " | ". $itm->update. "\r\n";
    // }
}
?>
