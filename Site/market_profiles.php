<?php
/*
    YOMARKET-PHP-LIB EXAMPLE 
*/

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

class Profile
{
		public $username;
        public $password;
		
        public $yoworld;
		public $yoworld_id;
		public $net_worth;
		public $badges;
		
        public $discord;
		public $discord_id;
		
        public $facebook;
		public $facebook_id;
		
        public $display_badges;
		public $display_worth;
		public $display_invo;
		public $display_fs;
		public $display_wtb;
		public $display_activity;
		
        public $activites;
        public $invo;
		public $fs_list;
		public $wtb_list;
        
        function __construct(array $acc_info_arr, array $profile_displays, array $acts, array $invo, array $fs, array $wtb)
        {
            if(count($acc_info_arr) < 8 || count($profile_displays) < 6)
                return;

            $this->username = $acc_info_arr[0]; $this->password = $acc_info_arr[1]; $this->yoworld = $acc_info_arr[2]; $this->yoworld_id = $acc_info_arr[3];
            $this->net_worth = $acc_info_arr[4]; $this->discord = $acc_info_arr[5]; $this->discord_id = $acc_info_arr[6];
            $this->facebook = $acc_info_arr[7]; $this->facebook_id = $acc_info_arr[8] ?? "";

            $this->activities = $acts;
            $this->invo = $invo;
            $this->fs_list = $fs;
            $this->wtb_list = $wtb;
        }

        public function retrieve_info(): string
        {
            return "$this->username,$this->password,$this->yoworld,$this->yoworld_id,$this->net_worth,$this->badges,$this->discord,$this->discord_id,$this->facebook,$this->facebook_id";
        }

        public function is_FbID(): bool 
        {
            if((int)$this->facebook_id > 0)
                return true;
            return false;
        }

        public static function act_to_profile(string $act_t): string 
        {
            switch($act_t) 
            {
                case "item_sold":
                    return "has sold";
                case "item_bought":
                    return "has bought";
                case "item_viewed": 
                    return "has viewed";
                case "price_change":
                    return "has change the price of";
            }

            return "";
        }
        
        public static function new_profile(array $info): Profile 
        {
            $new_p = new Profile(array("", "", "", "", "", "", "", "", ""), array("", "", "", "", "", "", ""), array(), array(), array(), array());
            if(count($info) < 8)
                return new Profile(array("", "", "", "", "", "", "", "", ""), array("", "", "", "", "", "", ""), array(), array(), array(), array());

            $new_p->username = $info[0]; $new_p->password = $info[1]; $new_p->yoworld = $info[2]; $new_p->yoworld_id = $info[3];
            $new_p->net_worth = $info[4]; $new_p->badges = $info[5]; $new_p->discord = $info[6];
            $new_p->discord_id = $info[7]; $new_p->facebook = $info[8]; $new_p->facebook_id = $info[9] ?? "";

            return $new_p;
        }
}

class Profiles
{
    public static function auth(string $user, string $pass, string $ip): Profile
    {
        try {
            $api_resp = file_get_contents("https://api.yomarket.info/auth?username=$user&password=$pass&ip=$ip");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Profile());
        }

        if(str_contains($api_resp, "[ X ]")) 
            return (new Profile());

        $lines = explode("\n", $api_resp);

        $acc_info = explode(",", Profiles::remove_strings($lines[0], array("[", "]")));
        $displays = explode(",", Profiles::remove_strings($lines[1], array("[", "]")));
        $activites = Profiles::find_acitivies($api_resp);
        $invo = Profiles::find_invo($api_resp);
        $fs = Profiles::find_fs($api_resp);
        $wtb = Profiles::find_wtb($api_resp);

        return (new Profile($acc_info, $displays, $activites, $invo, $fs, $wtb));
    }

    public static function find_profile(string $user, string $ip): Profile
    {
        try {
            $api_resp = file_get_contents("https://api.yomarket.info/profile?username=$user&ip=$ip");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Profile());
        }

        if(str_contains($api_resp, "[ X ]")) 
            return (new Profile());

        $lines = explode("\n", $api_resp);

        $acc_info = explode(",", Profiles::remove_strings($lines[0], array("[", "]")));
        $displays = explode(",", Profiles::remove_strings($lines[1], array("[", "]")));
        $activites = Profiles::find_acitivies($api_resp);
        $invo = Profiles::find_invo($api_resp);
        $fs = Profiles::find_fs($api_resp);
        $wtb = Profiles::find_wtb($api_resp);

        return (new Profile($acc_info, $displays, $activites, $invo, $fs, $wtb));
    }

    public static function find_invo(string $content): array
    {
        $invo_items = array();
        $lines = explode("\n", $content);

        $start_pulling = false;
        foreach($lines as $line)
        {
            if($line == "@ACTIVITIES" || $line == "@INVENTORY" || $line == "@FS" || $line == "@WTB")
                continue;
            if($line === "" && $start_pulling)
                break;
            
            if(str_contains($line, "@INVENTORY"))
                $start_pulling = true;

            if($start_pulling)
                array_push($invo_items, explode(",", Profiles::remove_strings($line, array("@INVENTORY", "[", "]"))));
        }
        
        return $invo_items;
    }

    public static function find_acitivies(string $content): array
    {
        $activites = array();
        $lines = explode("\n", $content);

        $start_pulling = false;
        foreach($lines as $line)
        {
            if($line == "@ACTIVITIES" || $line == "@INVENTORY" || $line == "@FS" || $line == "@WTB")
                continue;
            if($line === "" && $start_pulling)
                break;
            
            if(str_contains($line, "@ACTIVITIES"))
                $start_pulling = true;

            if($start_pulling)
                array_push($activites, explode(",", Profiles::remove_strings($line, array("@ACTIVITIES", "[", "]"))));
        }
        
        return $activites;
    }

    public static function find_fs(string $content): array
    {
        $fs = array();
        $lines = explode("\n", $content);

        $start_pulling = false;
        foreach($lines as $line)
        {
            if($line == "@ACTIVITIES" || $line == "@INVENTORY" || $line == "@FS" || $line == "@WTB")
                continue;
            if($line === "" && $start_pulling)
                break;
            
            if(str_contains($line, "@FS"))
                $start_pulling = true;

            if($start_pulling)
                array_push($fs, explode(",", Profiles::remove_strings($line, array("@FS", "[", "]"))));
        }
        
        return $fs;
    }

    public static function find_wtb(string $content): array
    {
        $wtb = array();
        $lines = explode("\n", $content);

        $start_pulling = false;
        foreach($lines as $line)
        {
            if($line == "@ACTIVITIES" || $line == "@INVENTORY" || $line == "@FS" || $line == "@WTB")
                continue;
            if($line === "" && $start_pulling)
                break;
            
            if(str_contains($line, "@WTB"))
                $start_pulling = true;

            if($start_pulling)
                array_push($wtb, explode(",", Profiles::remove_strings($line, array("@WTB", "[", "]"))));
        }
        
        return $wtb;
    }

    public static function remove_strings(string $str, array $arr): string 
    {
        $gg = $str;
        foreach($arr as $i)
        { $gg = str_replace("$i", "", $gg); }
        return $gg;
    }
}

?>