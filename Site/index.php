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
            <h6 class="mb-1">Dashboard</h6>
            <p class="text-sm">News and updates!</p>
          </div>

          <div class="card-body p-3">
            <li class="list-group-item border-0 d-flex align-items-center px-0 mb-2">
              <div class="avatar me-3">
                <img src="https://yoworld.com/images/icon.ico" alt="kal" class="border-radius-lg shadow">
              </div>
              <div class="d-flex align-items-start flex-column justify-content-center">
                <h6 class="mb-0 text-sm">Statistics update</h6>
                <p style="font-size: 15px;">The total search count has be restarted.</a></p>
                </div>
              <a class="btn btn-link pe-3 ps-0 mb-0 ms-auto" href="#">Jan 20, 2024</a>
            <span style="align: center; right: 0;"class="badge bg-success rounded">- YoMarket Owner</span>
            </li>
          </div>

          <div class="card-body p-3">
            <li class="list-group-item border-0 d-flex align-items-center px-0 mb-2">
              <div class="avatar me-3">
                <img src="https://yoworld.com/images/icon.ico" alt="kal" class="border-radius-lg shadow">
              </div>
              <div class="d-flex align-items-start flex-column justify-content-center">
                <h6 class="mb-0 text-sm">80-90% Of All 08/09 Updated</h6>
                <p style="font-size: 15px;">Today we took the time to update most 08/09 costumes along with other trending items people usually use with 08/09s. Enjoy!</a></p>
                </div>
              <a class="btn btn-link pe-3 ps-0 mb-0 ms-auto" href="#">Jan 18, 2024</a>
            <span style="align: center; right: 0;"class="badge bg-success rounded">- YoMarket Owner</span>
            </li>
          </div>

          <div class="card-body p-3">
            <li class="list-group-item border-0 d-flex align-items-center px-0 mb-2">
              <div class="avatar me-3">
                <img src="https://yoworld.com/images/icon.ico" alt="kal" class="border-radius-lg shadow">
              </div>
              <div class="d-flex align-items-start flex-column justify-content-center">
                <h6 class="mb-0 text-sm">Price Managers Needed!</h6>
                <p style="font-size: 15px;">We are looking for price managers to update items and help keep our yoworld safe from scams or price jackers! Contact us by submiting a ticket request in our discord! <a href="https://discord.gg/9rcuJ97dke">Click Here To Join</a></p>
                </div>
              <a class="btn btn-link pe-3 ps-0 mb-0 ms-auto" href="#">Jan 13, 2024</a>
            <span style="align: center; right: 0;"class="badge bg-success rounded">- YoMarket Owner</span>
            </li>
          </div>
          
          <div class="card-body p-3">
            <li class="list-group-item border-0 d-flex align-items-center px-0 mb-2">
              <div class="avatar me-3">
                <img src="https://yoworld.com/images/icon.ico" alt="kal" class="border-radius-lg shadow">
              </div>
              <div class="d-flex align-items-start flex-column justify-content-center">
                <h6 class="mb-0 text-sm">YoMarket Owner</h6>
                <p style="font-size: 15px;">Our new price guide YoMarket is now launched for public use!
If you experience any errors or bug. Please report it via YoMarket's discord</p>
                </div>
              <a class="btn btn-link pe-3 ps-0 mb-0 ms-auto" href="#">Jan 12, 2024</a>
            <span style="align: center; right: 0;"class="badge bg-success rounded">- YoMarket Owner</span>
            </li>
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