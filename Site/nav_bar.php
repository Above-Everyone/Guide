<!-- Navbar -->
<?php

include_once("market_profiles.php");

$info = $_COOKIE['ym_user_info'] ?? "";
$profile;

if(!empty($info)) { $profile = Profile::new_profile(explode(",", $info)); }

?>
<nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" navbar-scroll="true">
      <div class="container-fluid py-1 px-3" style="padding-right: 10%;">
        <nav aria-label="breadcrumb" style="padding-right: 30px;">
          <h1>YoMarket</h1>
            <p class="text-sm">The #1 Price Guide For Yoworld!</p>
        </nav>
        <div class="collapse navbar-collapse mt-sm-0 mt-2 me-md-0 me-sm-4" id="navbar">

          <ul class="navbar-nav  justify-content-end">
            <li class="nav-item d-flex align-items-center">
              <a href="index.php"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Home"/></a>
            </li>
          </ul>

          <ul class="navbar-nav  justify-content-end">
            <li class="nav-item d-flex align-items-center">
              <a href="search.php"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Item Search"/></a>
            </li>
          </ul>

          <ul class="navbar-nav  justify-content-end">
            <li class="nav-item d-flex align-items-center">
              <a href="recent.php"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Recent Items Updated"/></a>
            </li>
          </ul>

          <?php
          if(!empty($info)) {
            echo '<ul class="navbar-nav  justify-content-end">';
            echo '<li class="nav-item d-flex align-items-center">';
            echo '  <a href="admin_index.php"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Suggested Prices"/></a>';
            echo '</li>';
            echo '</ul>';
            echo '<ul class="navbar-nav  justify-content-end">';
            echo '<li class="nav-item d-flex align-items-center">';
            echo '  <a href="https://api.yomarket.info/save"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Save DB"/></a>';
            echo '</li>';
            echo '</ul>';
          }
          ?>

          <ul class="navbar-nav  justify-content-end">
            <li class="nav-item d-flex align-items-center">
              <a href="https://discord.gg/Uu6RRmw7HW"><input type="submit" class="btn btn-outline-primary btn-sm mb-0 me-3" target="_blank" value="Discord Server"/></a>
            </li>
          </ul>
        </div>

        
        <?php
          if(empty($info)) {
            echo '<ul class="navbar-nav  justify-content-end">';
            echo '<li class="nav-item d-flex align-items-center">';
            echo '  <a href="login.php" class="nav-link text-body font-weight-bold px-0">';
            echo '    <i class="fa fa-user me-sm-1"></i>';
            echo '    <span class="d-sm-inline d-none">Sign In</span>';
            echo '  </a>';
            echo '</li>';
            echo '</ul>';
          } else {
            
            echo '<ul class="navbar-nav  justify-content-end" style="padding-right: 20px;" >';
            echo '<li class="nav-item d-flex align-items-center">';
            echo '  <a href="#" class="nav-link text-body font-weight-bold px-0">';
            echo '    <i class="fa fa-user me-sm-1"></i>';
            echo '<p class="d-sm-inline d-none"> Welcome Back: '. $profile->username. '!</p>';
            echo '  </a>';
            echo '</li>';
            echo '</ul>';

            echo '<ul class="navbar-nav  justify-content-end">';
            echo '<li class="nav-item d-flex align-items-center">';
            echo '  <a href="#" class="nav-link text-body font-weight-bold px-0">';
            echo '    <i class="fa fa-user me-sm-1"></i>';
            echo '    <span class="d-sm-inline d-none">Sign Out</span>';
            echo '  </a>';
            echo '</li>';
            echo '</ul>';
          }
          ?>
      </div>
    </nav>
    <!-- End Navbar -->