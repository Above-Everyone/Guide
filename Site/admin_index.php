<?php

include_once("market_profiles.php");

$info = $_COOKIE['ym_user_info'] ?? "";
$profile;

if(empty($info))
{
    header('Location: index.php');
    exit();
} else {
    $profile = Profile::new_profile(explode(",", $info));
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
  <link rel="icon" type="image/png" sizes="16x16" href="https://yoworld.com/images/icon.ico">
  <title>YoMarket | Recent Updated Items</title>
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
  <script defer data-site="https://yomarket.info" src="https://api.nepcha.com/js/nepcha-analytics.js"></script>
</head>

<style>
.bg-success {
    background-color: #7ace4c!important;
}
.rounded {
    border-radius: 2px!important;
}
.badge {
    display: inline-block;
    padding: 0.35em 0.7em;
    font-size: 73%;
    font-weight: 300;
    line-height: 1;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: 2px;
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
    height: 100mh;
    width: 500px;
    border: solid;
}

/*
            Search Results Box & Grid Container
*/
.result_box {
    left: 0%;
    color: #fff;
    margin: auto;
    border-style: solid;
    border-color: #ff00;
    background-color: #fff;
}
.grid-container {
    display: grid;
    background-color: transparent;
    /* grid-template-columns: fit-content(300px) fit-content(300px) 6 2fr; */
    /* grid-template-columns: auto auto auto auto; */
    grid-template-columns: repeat(5, 1fr);
    grid-gap: 1px;
    box-sizing: border-box;
    padding: 10px;
}
.grid-item {
    color: #fff;
    background-color: #fff;
    border-style: groove;
    border-color: rgb(12, 11, 11);
    text-align: center;
}
.item-name {
    margin: auto;
    background-color: rgb(12, 11, 11);
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
</style>

<body class="g-sidenav-show  bg-gray-100">
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">

    <?php include_once("nav_bar.php"); ?>

    <div class="container-fluid py-4">
      <?php include_once("statistics.php"); ?>
      
        <div class="col-12 mt-4">
          <div class="card mb-4">
          <div class="card-header pb-0 p-3">
            <h6 class="mb-1">Recent Price Suggestions</h6>
            <p class="text-sm">Please investigate the recent price suggestions to set new prices.</p>
            <p class="text-sm">Lets keep our Yoworld community updated with prices and a smile on their face!</p>
          </div>
            <div class="card-body px-0 pt-0 pb-2">
              <div class="table-responsive p-0">
                <table class="table align-items-center mb-0">
                  <thead>
                    <tr>
                      <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Item Name/ID</th>
                      <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Price</th>
                      <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Update</th>
                    </tr>
                  </thead>
                  <tbody>
            <?php
                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);
                error_reporting(E_ALL);
                include_once("yomarket.php");

                $ip = $_SERVER["HTTP_CF_CONNECTING_IP"] ?? "";
                $agent = str_replace(" ", "_", $_SERVER["HTTP_USER_AGENT"] ?? "");
                $agent = str_replace(";", "-", $agent);

                $reversed = array_reverse(YoMarket::all_suggestions());

                foreach($reversed as $log)
                {
                    $line_info = explode(",", $log);
                    if(count($line_info) < 3) continue;
                    $t = "https://yw-web.yoworld.com/cdn/items/". substr($line_info[1], 0, 2). "/". substr($line_info[1], 2, 2). "/". $line_info[1]. "/". $line_info[1]. "_60_60.gif";
                    echo '<tr>';
                    echo '<td>';
                    echo '<div class="d-flex px-2 py-1">';
                    echo '<div>';
                    echo '<img src="'. $t. '" class="avatar avatar-sm me-3" alt="user1">';
                    echo '</div>';
                    echo '<div class="d-flex flex-column justify-content-center">';
                    echo '<h6 class="mb-0 text-sm">'. $line_info[0]. '</h6>';
                    echo '<p class="text-xs text-secondary mb-0">'. $line_info[1]. '</p>';
                    echo '</div>';
                    echo '</div>';
                    echo '<td class="align-middle text-center">';
                    echo '<span class="text-secondary text-xs font-weight-bold">'. $line_info[2]. '</span>';
                    echo '</td>';
                    echo '<td class="align-middle text-center">';
                    echo '<span class="text-secondary text-xs font-weight-bold">'. $line_info[3]. '</span>';
                    echo '</td>';
                    echo '</tr>';
                }
            ?>

            </tbody>
          </table>
              </div>
            </div>
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