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
.fit {
    color: #000;
    box-sizing: border-box;
}
.fit-price {
    color: #000;
    box-sizing: border-box;
    display: inline-block;
}
table, th, td {
  border:1px solid black;
}

.wrap-box {
    border-color: #fff;
    border-style: solid;
    padding: 50px;
    margin: 50px;
    align-items: center;
}
.result-box {
    border-color: #fff;
    border-style: solid;
    padding: 50px;
    margin: 50px;
    display: flex;
    width: 100mw;
    align-items: center;
}
.img-box {
    padding-left: 40px;
    display: flex;
    width: 200px;
    height: 200px;
    float:right;
}
.result-gap {
    width: 50px;
    height: 150px;
}
.info-box {
    right: 0%;
    border-color: #fff;
    border-style: solid;
    width: 300px;
    height: 350px;
    float:left;
    text-align: center;
}
.log-box {
    border-color: #000;
    border-style: solid;
    padding: 50px;
    margin: 50px;
    display: inline-block;
    align-items: center;
}
h1 {
    font-size: 20px;
    color: #cb0c9f;
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
                            var_dump($r);
                            echo "<p>Error, Unable to connect to YoMarket's API. Please try again (Try using all lowercase)</p><br /><p>This is a common bug we are working on fixing....!</p>";
                        } else if($r->type == ResponseType::EXACT)
                        {
                            echo '<center><form method="post"><div class="result-box">';
                            echo '<div class="img-box">';
                            echo '<img width="200" height="200" src="'. $r->result->url. '"/>';
                            echo '</div> ';
                            echo '<div class="result-gap"></div>';
                            echo '<div class="info-box">';
                            echo '<h1>'. $r->result->name.'</h1>';
                            echo '<p class="fit">ID: '. $r->result->id. '</p>';
                            echo '<p class="fit">Price: '. $r->result->price. '</p>';
                            echo '<p class="fit">Update: '. $r->result->update .'</p>';
                            echo '<p class="fit">In-Store: '. ($r->result->in_store == "" ? $r->result->in_store: "N/A") .'</p>';
                            echo '<p class="fit">Store Price: '. ($r->result->store_price == "" ? $r->result->store_price: "N/A"). '</p>';
                            echo '<p class="fit">Gender: '. ($r->result->gender == "" ? $r->result->gender: "N/A"). '</p>';
                            echo '<p class="fit">XP: '. ($r->result->xp == "" ? $r->result->xp: "N/A"). '</p>';
                            echo '<p class="fit">Category: '. ($r->result->category == "" ? $r->result->category: "N/A"). '</p>';
                            echo '<div class="mb-3"><input type="text" class="form-control" placeholder="New Price (Ex: 2m)" aria-label="Name" aria-describedby="email-addon" id="new_price" name="new_price"></div>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><input style="width: 200px;" type="submit" class="fit btn btn-success" id="price_btn" name="price_btn" value="Suggest"/></div></div>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="#">Request Price Check</a></div></div>';
                            echo '</div>';
                            echo '</div></form>';
                            echo '</div>';
                            echo '<br /><br />';
                            echo '<div style="height: 50px;"></div>';
                            echo '<div class="log-box">';
                            echo '<center><h1>Yoworld.Info\'s Price Change History</h1>';
                            foreach($r->result->yw_db_price as $price) 
                            {
                                $info = explode(",", $price);
                                echo '<div stlye="display: inline-block">';
                                echo '<p class="fit-price">Price: '. $info[0]. ' | </p>';
                                echo '<p class="fit-price">Update: '. $info[3]. '</p>';
                                echo '</div>';
                            }
                            echo '</center></div>';
                            echo '</div></center>';
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