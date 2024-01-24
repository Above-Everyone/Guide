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
    background-color: #cb0c9f;
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
            <form method="post">
                <div class="mb-3"><input type="text" class="form-control" placeholder="Name" aria-label="Name" aria-describedby="email-addon" id="item_query" name="item_query"></div><br />
                <div class="form-group mb-4"><div class="col-sm-12"><input type="submit" class="btn btn-success" style="width: 100mw" id="search_item" name="search_item" value="Search"/></div></div>
            </form>
                <?php
                    ini_set('display_errors', 0);
                    ini_set('display_startup_errors', 0);
                    // error_reporting(E_ALL);
                    include_once("yomarket.php");
                    $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];
                    $agent = str_replace(" ", "_", $_SERVER["HTTP_USER_AGENT"]);
                    $agent = str_replace(";", "-", $agent);
                    $eng = new YoMarket();
                    
                    if(array_key_exists("search_item", $_POST))
                    {
                        $itemID = $_POST['item_query'];

                        if(!isset($_POST['item_query']) || empty($itemID))
                            die("[ X ] Fill out GET parameters to continue...!");

                        $r = $eng->searchItem($itemID, $ip."&agent=". $agent);

                        if($r->type == ResponseType::API_FAILURE || $r->type == ResponseType::NONE)
                        {
                            var_dump($r);
                            echo "<p>Error, Unable to connect to YoMarket's API. Please try again (Try using all lowercase)</p><br /><p>This is a common bug we are working on fixing....!</p>";
                        } else if($r->type == ResponseType::EXACT)
                        {
                            echo '<center><form method="post"><div class="item_box" style="background-color: #fff;">';
                            echo '<div style="display: inline-block">';
                            echo '<img width="150" height="150" src="'. $r->result->url. '"/>';
                            echo '<p class="fit"><b>'. $r->result->name. '</b></p>';
                            echo '<p class="fit"><b>Item ID:</b> '. $r->result->id. '</p>';
                            echo '<p class="fit"><b>Item Price:</b> '. $r->result->price. '</p>';
                            echo '<p class="fit"><b>Item Update:</b> '. $r->result->update. '</p>';
                            echo '<p class="fit"><b>In-Store:</b> '. ($r->result->in_store == "0" ? "Yes":"No"). '</p>';
                            echo '<p class="fit"><b>In-Store Price:</b> '. ($r->result->store_price == "" ? "N/A": $r->result->store_price). '</p>';
                            echo '<p class="fit"><b>Gender:</b> '. $r->result->gender. '</p>';
                            echo '<p class="fit"><b>XP:</b> '. $r->result->xp. '</p>';
                            echo '<p class="fit"><b>Category:</b> '. $r->result->category. '</p>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="https://yomarket.info/more_info.php?iid='. $r->result->id. '">More Info</a></div></div>';
                            echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="#">Request Price Check</a></div></div>';
                            echo '</div>';
                            echo '</div></form></center>';
                        } else if($r->type == ResponseType::EXTRA)
                        { 
                            echo '<div class="result_box" style="margin-left: 0px">';
                            echo '<div class="grid-container">';
                            foreach($r->result as $item)
                            {
                                echo '<div class="grid-item">';
                                echo '<p class="item-name bg-gradient-primary" style="font-size: 15px; color: #ff0000"><b>'. $item->name. '</b></p>';
                                echo '<img style="padding-top: 20px;" width="100" height="100" src="'. $item->url. '" />';
                                echo '<p style="font-size: 15px;color: #ff0000">#'. $item->id. '</p>';
                                echo '<p style="font-size: 15px;color: #ff0000">Price: '. $item->price. '</p>';
                                echo '<p style="font-size: 15px;color: #ff0000">Last Update: '. $item->update. '</p>';
                                echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="https://yomarket.info/more_info.php?iid='. $item->id. '">More Info</a></div></div>';
                                echo '<div class="form-group mb-4"><div class="col-sm-12"><a class="fit btn btn-success" href="#">Request Price Check</a></div></div>';
                                echo '</div>';
                            }
                            echo '</div>';
                            echo '</div>';
                        } else {
                            echo '<a><font color="FF0000">[ X ] Error, No item was found...!</font></a>';
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