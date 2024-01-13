<!DOCTYPE html>
<html dir="ltr" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="keywords"
        content="wrappixel, admin dashboard, html css dashboard, web dashboard, bootstrap 5 admin, bootstrap 5, css3 dashboard, bootstrap 5 dashboard, Ample lite admin bootstrap 5 dashboard, frontend, responsive bootstrap 5 admin template, Ample admin lite dashboard bootstrap 5 dashboard template">
    <meta name="description" content="The Official #1 Price Guide For Yoworld Items. Helping the yoworld community prevent scams!">
    <meta name="robots" content="noindex,nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YoMarket | Item Search (Desktop)</title>
    <link rel="canonical" href="https://www.wrappixel.com/templates/ample-admin-lite/" />
    <!-- Favicon icon -->
    <link rel="icon" type="image/png" sizes="16x16" href="https://yoworld.com/images/icon.ico">
    <!-- Custom CSS -->
    <link href="plugins/bower_components/chartist/dist/chartist.min.css" rel="stylesheet">
    <link rel="stylesheet" href="plugins/bower_components/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.css">
    <!-- Custom CSS -->
    <link href="css/style.min.css" rel="stylesheet">
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
    max-width: 500px;
    background-color: #fff;
}
.grid-container {
    display: grid;
    background-color: transparent;
    grid-template-columns: fit-content(300px) fit-content(300px) 2 2fr;
    /* grid-template-columns: auto auto auto auto; */
    grid-gap: 5px;
    box-sizing: border-box;
    height: 100mh;
    width: 100mw;
    padding: 10px;
}
.grid-item {
    color: #fff;
    background-color: #fff;
    border-style: groove;
    border-color: rgb(12, 11, 11);
    width: 200px;
    text-align: center;
}
.item-name {
    margin: auto;
    background-color: rgb(12, 11, 11);
    box-sizing: border-box;
    width: 100mw;
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

<body>
    <!-- ============================================================== -->
    <!-- Preloader - style you can find in spinners.css -->
    <!-- ============================================================== -->
    <div class="preloader">
        <div class="lds-ripple">
            <div class="lds-pos"></div>
            <div class="lds-pos"></div>
        </div>
    </div>
    <!-- ============================================================== -->
    <!-- Main wrapper - style you can find in pages.scss -->
    <!-- ============================================================== -->
    <div id="main-wrapper" data-layout="vertical" data-navbarbg="skin5"
         data-header-position="absolute" data-boxed-layout="full">
        <!-- ============================================================== -->
        <!-- Topbar header - style you can find in pages.scss -->
        <!-- ============================================================== -->
        <header class="topbar" data-navbarbg="skin5">
            <nav class="navbar top-navbar navbar-expand-md navbar-dark">
                <div class="navbar-header" data-logobg="skin6">
                    

                    <a class="navbar-brand" style="background-color: #2f323e;" href="dashboard.html">
                        <!-- Logo icon -->
                        <b class="logo-icon">
                            <!-- Dark Logo icon -->
                            <h1 style="color: #ff0000"><b>YoMarket</b></h1>
                        </b>
                        <!--End Logo icon -->
                        <!-- Logo text -->
                        <span class="logo-text">
                            <!-- dark Logo text -->
                        </span>
                    </a>
                    <!-- ============================================================== -->
                    <!-- End Logo -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- toggle and nav items -->
                    <!-- ============================================================== -->
                    <a class="nav-toggler waves-effect waves-light text-dark d-block d-md-none"
                        href="javascript:void(0)"><i class="ti-menu ti-close"></i></a>
                    
                </div>
                <!-- ============================================================== -->
                <!-- End Logo -->
                <!-- ============================================================== -->
                <div class="navbar-collapse collapse" id="navbarSupportedContent" data-navbarbg="skin5">
                   
                    <li class="sidebar-item pt-2">
                        <a class="sidebar-link waves-effect waves-dark sidebar-link" href="https://discord.gg/Z4kj3xGsTH"
                            aria-expanded="false">
                            <span class="hide-menu">Discord Server</span>
                        </a>
                    </li>
                    <!-- ============================================================== -->
                    <!-- Right side toggle and nav items -->
                    <!-- ============================================================== -->
                    <ul class="navbar-nav ms-auto d-flex align-items-center">

                        <!-- ============================================================== -->
                        <!-- Search -->
                        <!-- ============================================================== -->
                        <li class=" in">
                            <form role="search" class="app-search d-none d-md-block me-3">
                                <input type="text" placeholder="Search..." class="form-control mt-0">
                                <a href="" class="active">
                                    <i class="fa fa-search"></i>
                                </a>
                            </form>
                        </li>
                        <!-- ============================================================== -->
                        <!-- User profile and search -->
                        <!-- ============================================================== -->
                        <li>
                            <a class="profile-pic" href="#">
                                <img src="https://puu.sh/JYHXC/7f0281542c.png" alt="user-img" width="36"
                                    class="img-circle"><span class="text-white font-medium">Steave</span></a>
                        </li>
                        <!-- ============================================================== -->
                        <!-- User profile and search -->
                        <!-- ============================================================== -->
                    </ul>
                </div>
            </nav>
        </header>
        <!-- ============================================================== -->
        <!-- End Topbar header -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- Left Sidebar - style you can find in sidebar.scss  -->
        <!-- ============================================================== -->
        <?php include_once("side_bar.php"); ?>
        <!-- ============================================================== -->
        <!-- End Left Sidebar - style you can find in sidebar.scss  -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        <div class="page-wrapper">
            <!-- ============================================================== -->
            <!-- Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <div class="page-breadcrumb bg-white">
                <div class="row align-items-center">
                    <div class="col-lg-3 col-md-4 col-sm-4 col-xs-12">
                        <h4 class="page-title">Dashboard</h4>
                    </div>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- ============================================================== -->
            <!-- End Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            
            <!-- ============================================================== -->
            <!-- Container fluid  -->
            <!-- ============================================================== -->
            <div class="container-fluid">
                <!-- ============================================================== -->
                <!-- Three charts -->
                <!-- ============================================================== -->
                <div class="row justify-content-center">
                    <div class="col-lg-4 col-md-12">
                        <div class="white-box analytics-info">
                            <h3 class="box-title">Database Items</h3>
                            <ul class="list-inline two-part d-flex align-items-center mb-0">
                                <li>
                                    <div id="sparklinedash"><canvas width="67" height="30"
                                            style="display: inline-block; width: 67px; height: 30px; vertical-align: top;"></canvas>
                                    </div>
                                </li>
                                <li class="ms-auto"><span class="counter text-success">0</span></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-12">
                        <div class="white-box analytics-info">
                            <h3 class="box-title">Total Searches</h3>
                            <ul class="list-inline two-part d-flex align-items-center mb-0">
                                <li>
                                    <div id="sparklinedash2"><canvas width="67" height="30"
                                            style="display: inline-block; width: 67px; height: 30px; vertical-align: top;"></canvas>
                                    </div>
                                </li>
                                <li class="ms-auto"><span class="counter text-purple">0</span></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-12">
                        <div class="white-box analytics-info">
                            <h3 class="box-title">Unique Visitor</h3>
                            <ul class="list-inline two-part d-flex align-items-center mb-0">
                                <li>
                                    <div id="sparklinedash3"><canvas width="67" height="30"
                                            style="display: inline-block; width: 67px; height: 30px; vertical-align: top;"></canvas>
                                    </div>
                                </li>
                                <li class="ms-auto"><span class="counter text-info">0</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- ============================================================== -->
                <!-- PRODUCTS YEARLY SALES -->
                <!-- ============================================================== -->
                <div class="row">
                    <div class="col-md-12 col-lg-12 col-sm-12 col-xs-12">
                        <div class="white-box">
                            <h3 class="box-title">Item Search</h3>

                            <?php
                                ini_set('display_errors', 1);
                                ini_set('display_startup_errors', 1);
                                // error_reporting(E_ALL);
                                include_once("yomarket.php");
                                $item = "";

                                if(array_key_exists("iid", $_GET))
                                {
                                    $itemID = $_GET['iid'];
                                    $ip = $_SERVER["HTTP_CF_CONNECTING_IP"];

                                    if(!isset($_GET['iid']) || empty($itemID))
                                        die("[ X ] Fill out GET parameters to continue...!");

                                    $eng = new YoMarket();
                                    $r = $eng->searchItem($itemID, $ip);

                                    if($r->type == ResponseType::EXACT)
                                    {
                                        echo '<center><form method="post"><div class="item_box">';
                                        echo '<img width="150" height="150" src="'. $r->result->url. '"/>';
                                        echo '<div style="display: inline-block">';
                                        echo '<p><b>'. $r->result->name. '</b></p>';
                                        echo '<p><b>Item ID:</b> '. $r->result->id. '</p>';
                                        echo '<p><b>Item Price:</b> '. $r->result->price. '</p>';
                                        echo '<p><b>Item Update:</b> '. $r->result->update. '</p>';
                                        echo '<p><b>In-Store:</b> '. ($r->result->in_store == "0" ? "Yes":"No"). '</p>';
                                        echo '<p><b>In-Store Price:</b> '. ($r->result->store_price == "" ? "N/A": $r->result->store_price). '</p>';
                                        echo '<p><b>Gender:</b> '. $r->result->gender. '</p>';
                                        echo '<p><b>XP:</b> '. $r->result->xp. '</p>';
                                        echo '<p><b>Category:</b> '. $r->result->category. '</p>';
                                        echo '<input type="text" id="new_price" name="new_price" placeholder="New Price (Ex: 2m)"/>';
                                        echo '<input type="submit" id="price_btn" name="price_btn" value="Suggest"/>';
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
                                    $r = $eng->searchItem($itemID, $ip);

                                    $change_r = YoMarket::change_price($r->result, $n_price, $ip);
                                    
                                    if($change_r->type == ResponseType::ITEM_UPDATED)
                                    {
                                        // $format = YoGuide::format_change_log($ip, $itemID, $r->result->price, $n_price);
                                        // YoGuide::send_post_req((new YoGuide())->CHANGE_LOG_URL, $format);
                                        echo "<center><p>Item ". $r->result->name. " successfully updated....!</p><center>";
                                    } else if($change_r->type == ResponseType::FAILED_TO_UPDATE)
                                    {
                                        // $format = YoGuide::format_suggestion_log($ip, $itemID, $r->result->price, $n_price);
                                        // YoGuide::send_post_req((new YoGuide())->SUGGEST_LOG_URL, $format);
                                        echo "<center><p>Price Suggestion sent to YoGuide Admins....!</p><center>";
                                    }
                                }

                            ?>
                        </div>
                    </div>
                </div>
                <!-- ============================================================== -->
                <!-- RECENT SALES -->
                <!-- ============================================================== -->
                
                <!-- ============================================================== -->
                <!-- Recent Comments -->
                <!-- ============================================================== -->
                
            </div>
            <!-- ============================================================== -->
            <!-- End Container fluid  -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- footer -->
            <!-- ============================================================== -->
            <footer class="footer text-center"> 2021 © YoMarket Team | <a
                    href="https://discord.gg/Z4kj3xGsTH">Discord</a>
            </footer>
            <!-- ============================================================== -->
            <!-- End footer -->
            <!-- ============================================================== -->
        </div>
        <!-- ============================================================== -->
        <!-- End Page wrapper  -->
        <!-- ============================================================== -->
    </div>
    <!-- ============================================================== -->
    <!-- End Wrapper -->
    <!-- ============================================================== -->
    <!-- ============================================================== -->
    <!-- All Jquery -->
    <!-- ============================================================== -->
    <script src="plugins/bower_components/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap tether Core JavaScript -->
    <script src="bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app-style-switcher.js"></script>
    <script src="plugins/bower_components/jquery-sparkline/jquery.sparkline.min.js"></script>
    <!--Wave Effects -->
    <script src="js/waves.js"></script>
    <!--Menu sidebar -->
    <script src="js/sidebarmenu.js"></script>
    <!--Custom JavaScript -->
    <script src="js/custom.js"></script>
    <!--This page JavaScript -->
    <!--chartis chart-->
    <script src="plugins/bower_components/chartist/dist/chartist.min.js"></script>
    <script src="plugins/bower_components/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>
    <script src="js/pages/dashboards/dashboard1.js"></script>
</body>

</html>