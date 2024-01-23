<!--
=========================================================
* Soft UI Dashboard - v1.0.7
=========================================================

* Product Page: https://www.creative-tim.com/product/soft-ui-dashboard
* Copyright 2023 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://www.creative-tim.com/license)
* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-->
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
  <link rel="icon" type="image/png" sizes="16x16" href="https://yoworld.com/images/icon.ico">
  <title>YoMarket | Item Search (Desktop)</title>
  <!--     Fonts and icons     -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
  <!-- Nucleo Icons -->
  <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
  <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
  <!-- Font Awesome Icons -->
  <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
  <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
  <!-- CSS Files -->
  <link id="pagestyle" href="assets/css/soft-ui-dashboard.css?v=1.0.7" rel="stylesheet" />
  <!-- Nepcha Analytics (nepcha.com) -->
  <!-- Nepcha is a easy-to-use web analytics. No cookies and fully compliant with GDPR, CCPA and PECR. -->
  <script defer data-site="YOUR_DOMAIN_HERE" src="https://api.nepcha.com/js/nepcha-analytics.js"></script>
</head>

<style>
    .item-info-box {
    margin: auto;
    background-color: #fff;
    height: 100mh;
    width: 500px;
    border: solid;
}
.main-item-info {
    margin: 0 auto;
    display: inline-block;
    text-align: center;

}
.item_img {
    margin: auto;
    align: center;
}
.extra_info {
    margin: 0 auto;
    display: inline-block;
    text-align: center;
}
    .txtt-input {
    font-size: 20px;
    margin: auto;
    border-style: solid;
    border-color: #0c0d10;
    color: #000;
    background-color: #fff;
}
.btnn-input {
    font-size: 20px;
    margin: auto;
    border-style: solid;
    border-color: #0c0d10;
    color: #fff;
    background-color: #fff;
    font-size: 20px;
}

.item_box {
    background-color: #fff;
    display: inline-block;
    height: 100mh;
    width: 500px;
    border: solid;
}

/*
            Search Results Box & Grid Container
*/
.result_box {
    color: #fff;
    margin: auto;
    border-style: solid;
    border-color: #fff;
    background-color: #fff;
}
.grid-container {
    display: grid;
    background-color: transparent;
    /* grid-template-columns: fit-content(300px) fit-content(300px) 6 2fr; */
    /* grid-template-columns: auto auto auto auto; */
    grid-template-columns: repeat(5, 1fr);
    grid-gap: 5px;
    box-sizing: border-box;
    padding: 10px;
}
.grid-item {
    color: #fff;
    background-color: #fff;
    border-style: groove;
    border-color: #cb0c9f;
    text-align: center;
}
.item-name {
    margin: auto;
    background-color: #cb0c9f;
    box-sizing: border-box;
    width: 100mw;
    height: 50px;
}
/*
            Buttons And Textboxes
*/
.txt-input {
font-size: 20px;
    border-style: solid;
    border-color: #fff;
    color: #fff;
    background-color: rgba(42, 42, 42);
}
.btn-input {
    font-size: 20px;
    border-style: solid;
    border-color: #fff;
    color: #fff;
    background-color: #0c0d10;
    font-size: 20px;
}
.fit {
    
    box-sizing: border-box;
}
table, th, td {
  border:1px solid black;
}
</style>

<body class="g-sidenav-show  bg-gray-100">
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">

    <?php include_once("nav_bar.php"); ?>

    <div class="container-fluid py-4">
      <?php include_once("statistics.php"); ?>
      
      <div class="col-12 mt-4">
        <div class="card mb-4">
          <div class="card-header pb-0 p-3">
            <h6 class="mb-1">YoMarket</h6>
            <p class="text-sm">The #1 Price Guide For Yoworld!</p>
          </div>
          <div class="card-body p-3">
                <?php
                    ini_set('display_errors', 0);
                    ini_set('display_startup_errors', 0);
                    // error_reporting(E_ALL);
                    include_once("yomarket.php");
                    $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];
                    $agent = str_replace(" ", "_", $_SERVER["HTTP_USER_AGENT"]);
                    $agent = str_replace(";", "-", $agent);
                    
                    if(array_key_exists("iid", $_GET))
                    {
                        $itemID = $_GET['iid'];
                        $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];

                        if(!isset($_GET['iid']) || empty($itemID))
                            die("[ X ] Fill out GET parameters to continue...!");

                        $eng = new YoMarket();
                        $r = $eng->searchItem($itemID, "");

                        if($r->type == ResponseType::API_FAILURE || $r->type == ResponseType::NONE)
                        {
                            echo "<p>Error, Unable to connect to YoMarket's API. Please try again (Try using all lowercase)</p><br /><p>This is a common bug we are working on fixing....!</p>";
                        } else if($r->type == ResponseType::EXACT)
                        {
                            echo '<form method="post"><div class="item-info-box">';
                            echo '<div style="width: 100px;">';
                            echo '<img class="item_img" width="150" height="150" src="'. $r->result->url .'"/>';
                            echo '</div>';
                            echo '<center><div class="extra_info">';
                            echo '<p>'. $r->result->name.'</p>';
                            echo '<p>Item ID: '. $r->result->id. '</p>';
                            echo '<p>Item Price: '. $r->result->price. '</p>';
                            echo '<p>Item Update: '. $r->result->update .'</p>';
                            echo '<p>In-Store:  '. $r->result->in_store .'</p>';
                            echo '<p>In-Store Price: '. $r->result->store_price. '</p>';
                            echo '<p>Gender: '. $r->result->gender.' </p>';
                            echo '<p>XP: '. $r->result->xp. '</p>';
                            echo '<p>Category: '. $r->result->category. '</p>';
                            echo '<input type="text" id="new_price" name="new_price" placeholder="New Price (Ex: 2m)"/>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><input type="submit" class="fit btn btn-success" id="price_btn" name="price_btn" value="Suggest"/></div></div>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="#">Request Price Check</a></div></div>';
                            echo '<br /><br />';
                            echo '</div>';
                            echo '</div></form></center>';
                        } else {
                            echo "[ X ] Error, No item was found...!";
                        }
                    } else {
                        die("[ X ] No Item ID Provided To Search For Item Information....!");
                    }

                    if(array_key_exists("price_btn", $_POST))
                    {
                        $itemID = $_GET['iid'];
                        $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];
                        $n_price = $_POST['new_price'] == "" ? "0": $_POST['new_price'];

                        if(!isset($_GET['iid']) || empty($itemID))
                            die("[ X ] Fill out GET parameters to continue...!");
                        
                        $eng = new YoMarket();
                        $r = $eng->searchItem($itemID, "");

                        $change_r = $eng->change_price($r->result, $n_price, $ip);
                        
                        if($change_r->type == ResponseType::ITEM_UPDATED)
                        {
                            // $format = YoGuide::format_change_log($ip, $itemID, $r->result->price, $n_price);
                            // YoGuide::send_post_req((new YoGuide())->CHANGE_LOG_URL, $format);
                            echo "<center><p>Item ". $r->result->name. " successfully updated....!</p><center>";
                        } else if($r->type == ResponseType::FAILED_TO_UPDATE)
                        {
                            // $format = YoGuide::format_suggestion_log($ip, $itemID, $r->result->price, $n_price);
                            // YoGuide::send_post_req((new YoGuide())->SUGGEST_LOG_URL, $format);
                            YoMarket::suggest_price($r->result, $n_price, $ip);
                            echo "<center><p>Price Suggestion sent to YoGuide Admins....!</p><center>";
                        }
                    }
                ?>
          </div>
        </div>
      </div>

      
      <?php include_once("footer.php"); ?>

    </div>
  </main>
  
  <!-- Github buttons -->
  <script async defer src="https://buttons.github.io/buttons.js"></script>
  <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
  <script src="assets/js/soft-ui-dashboard.min.js?v=1.0.7"></script>
</body>

</html>